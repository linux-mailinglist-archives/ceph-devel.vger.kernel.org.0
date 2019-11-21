Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7271048B2
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 03:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKUCqk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Nov 2019 21:46:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45418 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725819AbfKUCqk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 21:46:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574304399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2ulGRMd4WQGIx+ZoGmhGJhO+7LsywXlb9sip7IA/xk=;
        b=bpcrQRyT37haVAfVwBJU0fz0ztOI7suuoAx2qCejjfw+Mi8oQ7w/I3NTVeCYfw/L2kREn1
        SMD8x3LVRfAg86hzeZ/5XmAA3iAnMcrSbW7YD29tNA3eWixrfbLQJ107mBphS0pR51mG4g
        HVXumvWRoZRZ0D3dPzVSIwNLpC8SFUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-GraL7A8DOyWNVWseyGxCWQ-1; Wed, 20 Nov 2019 21:46:36 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 826A7107ACC5;
        Thu, 21 Nov 2019 02:46:35 +0000 (UTC)
Received: from [10.72.12.177] (ovpn-12-177.pek2.redhat.com [10.72.12.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2E7D50FC7;
        Thu, 21 Nov 2019 02:46:27 +0000 (UTC)
Subject: Re: [PATCH 3/3] mdsmap: only choose one MDS who is in up:active state
 without laggy
To:     xiubli@redhat.com, jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191120082902.38666-1-xiubli@redhat.com>
 <20191120082902.38666-4-xiubli@redhat.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <bd733875-f491-ea06-335a-e2856a76dea8@redhat.com>
Date:   Thu, 21 Nov 2019 10:46:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191120082902.38666-4-xiubli@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: GraL7A8DOyWNVWseyGxCWQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/20/19 4:29 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> Even the MDS is in up:active state, but it also maybe laggy. Here
> will skip the laggy MDSs.
>=20
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/mds_client.c |  6 ++++--
>   fs/ceph/mdsmap.c     | 13 +++++++++----
>   2 files changed, 13 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 82a929084671..a4e7026aaec9 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -972,7 +972,8 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>   =09=09=09=09     frag.frag, mds,
>   =09=09=09=09     (int)r, frag.ndist);
>   =09=09=09=09if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=3D
> -=09=09=09=09    CEPH_MDS_STATE_ACTIVE)
> +=09=09=09=09    CEPH_MDS_STATE_ACTIVE &&
> +=09=09=09=09    !ceph_mdsmap_is_laggy(mdsc->mdsmap, mds))
>   =09=09=09=09=09goto out;
>   =09=09=09}
>  =20
> @@ -987,7 +988,8 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>   =09=09=09=09     "frag %u mds%d (auth)\n",
>   =09=09=09=09     inode, ceph_vinop(inode), frag.frag, mds);
>   =09=09=09=09if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=3D
> -=09=09=09=09    CEPH_MDS_STATE_ACTIVE)
> +=09=09=09=09    CEPH_MDS_STATE_ACTIVE &&
> +=09=09=09=09    !ceph_mdsmap_is_laggy(mdsc->mdsmap, mds))
>   =09=09=09=09=09goto out;
>   =09=09=09}
>   =09=09}
for use USE_AUTH_MDS case, request can only be handled by auth mds.=20
client should send request to auth mds even it seems laggy.


> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 8b4f93e5b468..098669e6f1e4 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -13,6 +13,7 @@
>  =20
>   #include "super.h"
>  =20
> +#define CEPH_MDS_IS_READY(i) (m->m_info[i].state > 0 && !m->m_info[i].la=
ggy)
>  =20
>   /*
>    * choose a random mds that is "up" (i.e. has a state > 0), or -1.
> @@ -23,12 +24,16 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
>   =09int i, j;
>  =20
>   =09/* special case for one mds */
> -=09if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0)
> -=09=09return 0;
> +=09if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0) {
> +=09=09if (m->m_info[0].laggy)
> +=09=09=09return -1;
> +=09=09else
> +=09=09=09return 0;
> +=09}
>  =20
>   =09/* count */
>   =09for (i =3D 0; i < m->m_num_mds; i++)
> -=09=09if (m->m_info[i].state > 0)
> +=09=09if (CEPH_MDS_IS_READY(i))
>   =09=09=09n++;
>   =09if (n =3D=3D 0)
>   =09=09return -1;
> @@ -36,7 +41,7 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
>   =09/* pick */
>   =09n =3D prandom_u32() % n;
>   =09for (j =3D 0, i =3D 0; i < m->m_num_mds; i++) {
> -=09=09if (m->m_info[i].state > 0)
> +=09=09if (CEPH_MDS_IS_READY(i))
>   =09=09=09j++;
>   =09=09if (j > n)
>   =09=09=09break;
>=20

