# Trabajo final MundosE DevOps

## Descripción

Este repositorio contiene la infraestructura como código (IaC) para desplegar y gestionar un clúster de Kubernetes en AWS utilizando Amazon EKS, junto con los recursos necesarios para la capa de red, roles IAM, almacenamiento, y configuración de nodos y bastión. Además, incluye scripts para la preparación y configuración del entorno.

Es un proyecto orientado a facilitar la provisión automatizada y reproducible de la infraestructura en la nube para entornos de orquestación de contenedores.

## Estructura del proyecto

- **Archivos `.tf`**: Código Terraform para desplegar recursos como VPC, subredes, grupos de nodos, roles IAM, EBS, Clúster EKS y bastión.
- **`user_data.sh`**: Script que se ejecuta en instancias EC2 para configurar nodos o bastión al inicializarlos.
- **`app-ngnix/`**: Carpeta con recursos relacionados con una aplicación basada en Nginx.
- **`docs/`**: Documentación complementaria.
- **`monitoring/`**: Configuraciones o scripts para monitoreo.
- **`infra/`**: Módulos o definiciones adicionales de infraestructura.

## Requisitos previos

- Tener instalado [Terraform](https://www.terraform.io/downloads.html).
- Tener instalado y configurado el [AWS CLI](https://aws.amazon.com/cli/).
- Configurar tus credenciales de AWS (por ejemplo, usando `aws configure`).
- Conocimientos básicos sobre AWS y Kubernetes.

## Cómo usar este repositorio

### Paso a paso para desplegar la infraestructura

1. **Clonar el repositorio**
```bash
git clone https://github.com/RodriLll/trabajo_final_mundose.git
cd trabajo_final_mundose/infra
```

2. **Inicializar Terraform**
```bash
terraform init
```

3. **Revisar el plan de ejecución**
```bash
terraform plan
```

4. **Aplicar la configuración para crear la infraestructura en AWS**
```bash
terraform apply
```

Confirma la operación cuando se te solicite. Ten en cuenta que la provisión del clúster puede tardar varios minutos.

5. **Configurar el acceso al clúster EKS con `kubectl`**

Ejecuta el siguiente comando para actualizar el archivo de configuración de Kubernetes y poder interactuar con el clúster:
```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name main
```

6. **Verificar que los nodos estén listos**
```bash
kubectl get nodes
```

Deberías ver tus nodos listados y en estado `Ready`.

7. **Desplegar la aplicación 2048 y Nginx**

En la carpeta `app-nginx` se encuentran los manifiestos para desplegar un servidor Nginx y una aplicación web con el juego 2048. Usa `terraform init`, `terraform apply` para desplegar esta aplicación de ejemplo.

8. **Desplegar Prometheus y Grafana para monitoreo**

En la carpeta `monitoring` se encuentran configuraciones para desplegar Prometheus y Grafana en el clúster EKS usando Helm y configuraciones compatibles con Terraform. Esto permite recolectar métricas del clúster y visualizar dashboards en Grafana para monitorear el desempeño y estado de tus aplicaciones y la infraestructura.

Para desplegarlos, usa `terraform init`, `terraform apply`. Revisa los archivos dentro de `monitoring/` para más detalles.

9. **Verificar que Prometheus y Grafana estén corriendo**
```bash
kubectl get all -n prometheus
kubectl get all -n grafana
```

Deberías ver los pods y servicios de Prometheus y Grafana activos.

10. **Acceder a Grafana**

Para acceder a Grafana, listamos los servicios en el namespace `grafana`:
```bash
kubectl get svc -n grafana
```
Y en la lista copiar el external IP del servicio `service/grafana`.

11. **Destruir la infraestructura**

 Para evitar costos cuando no uses más la infraestructura:

 ```bash
 terraform destroy
 ```

## Notas importantes

- Asegúrate de tener configuradas correctamente tus credenciales de AWS.
- Terraform, AWS CLI y `kubectl` deben estar instalados en tu máquina.
- El despliegue puede tardar entre 15 y 30 minutos, dependiendo de la región y la configuración.
- Revisa los archivos `.tf`, `user_data.sh`, y el contenido de las carpetas `app-nginx` y `monitoring` para adaptar configuraciones específicas.

## Autores

- Rodrigo Llanos.
- Gastón Valvassori.

---

## Recursos adicionales

- [Documentación oficial de Terraform](https://www.terraform.io/docs)
- [Guía oficial de Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Prometheus y Grafana para Kubernetes](https://grafana.com/docs/grafana/latest/installation/kubernetes/)
