Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EE1117F77
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2019 06:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfLJFPC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Dec 2019 00:15:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28909 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725857AbfLJFPC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Dec 2019 00:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575954901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pI6ZILHZn0um0LLjEs5xZiAM5xEhGkB8+ib+7m4gKCQ=;
        b=BivNSX9bRBjoXi2GS4HjvaEpIW2ftKsODJihMFbAI9xIFjPNHKFs7+HaGIZSK2JeLMoHK8
        Z8hQTqqP6m8+hHqQT2wEsJsX0dHJn3oHuL2aSUGTODXs+reImsCCQS3xDoRpMjemXxNld4
        TqVgG1MqYXj61gr/tZvN9QfYlfvW0kw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-w2MQFckPOoW38jI-TieMbA-1; Tue, 10 Dec 2019 00:14:57 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2D28107ACC4;
        Tue, 10 Dec 2019 05:14:56 +0000 (UTC)
Received: from [10.72.12.181] (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D1E45D6D2;
        Tue, 10 Dec 2019 05:14:52 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: check availability of mds cluster on mount after
 wait timeout
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191127083508.12102-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d8999430-5860-8aca-f6ca-4aa51df716bd@redhat.com>
Date:   Tue, 10 Dec 2019 13:14:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191127083508.12102-1-xiubli@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: w2MQFckPOoW38jI-TieMbA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Checked the new mount API, still need this patch to do the check.

The following is the simple V3 patch, it will return -ESTALE to the=20
userland if the cluster is laggy or no MDS is up, then in the mount.ceph=20
we can check it and print some hint about the "cluster is laggy or no=20
MDS is up", will it make sense ?

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7d3ec051f179..1065190e00df 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2577,7 +2577,6 @@ static void __do_request(struct ceph_mds_client *mdsc=
,
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CEPH_MOUNT_OPT_MOUNT=
WAIT) &&
!ceph_mdsmap_is_cluster_available(mdsc->mdsmap)) {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D =
-ENOENT;
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_info("proba=
bly no mds server is up\n");
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fin=
ish;
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9c9a7c68eea3..da3aee796c17 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1068,6 +1068,11 @@ static int ceph_get_tree(struct fs_context *fc)
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;

 =C2=A0out_splat:
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ceph_mdsmap_is_cluster_available=
(fsc->mdsc->mdsmap)) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 pr_info("No mds server is up or the cluster is laggy\n");
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 err =3D -ESTALE;
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
+
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_mdsc_close_sessions(fsc->m=
dsc);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 deactivate_locked_super(sb);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_final;




BRs

On 2019/11/27 16:35, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> If all the MDS daemons are down for some reasons and for the first
> time to do the mount, it will fail with IO error after the mount
> request timed out.
>
> Or if the cluster becomes laggy suddenly, and just before the kclient
> getting the new mdsmap and the mount request is fired off, it also
> will fail with IO error.
>
> This will add some useful hint message by checking the cluster state
> before the fail the mount operation.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/mds_client.c | 4 ++--
>   fs/ceph/super.c      | 4 ++++
>   2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 109ec7e2ee7b..163b470f3000 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2556,7 +2556,7 @@ static void __do_request(struct ceph_mds_client *md=
sc,
>   =09=09      CEPH_MOUNT_OPT_MOUNTWAIT) &&
>   =09=09    !ceph_mdsmap_is_cluster_available(mdsc->mdsmap)) {
>   =09=09=09err =3D -ENOENT;
> -=09=09=09pr_info("probably no mds server is up\n");
> +=09=09=09pr_info("No mds server is up or the cluster is laggy\n");
>   =09=09=09goto finish;
>   =09=09}
>   =09}
> @@ -2706,7 +2706,7 @@ static int ceph_mdsc_wait_request(struct ceph_mds_c=
lient *mdsc,
>   =09=09if (timeleft > 0)
>   =09=09=09err =3D 0;
>   =09=09else if (!timeleft)
> -=09=09=09err =3D -EIO;  /* timed out */
> +=09=09=09err =3D -ETIMEDOUT;  /* timed out */
>   =09=09else
>   =09=09=09err =3D timeleft;  /* killed */
>   =09}
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index af2754b80b7c..39810677e601 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1137,6 +1137,10 @@ static struct dentry *ceph_mount(struct file_syste=
m_type *fs_type,
>   =09return res;
>  =20
>   out_splat:
> +=09if (PTR_ERR(res) =3D=3D -ETIMEDOUT &&
> +=09    !ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap))
> +=09=09pr_info("No mds server is up or the cluster is laggy\n");
> +
>   =09ceph_mdsc_close_sessions(fsc->mdsc);
>   =09deactivate_locked_super(sb);
>   =09goto out_final;


