Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAEE110092
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 15:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfLCOr1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 09:47:27 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31005 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbfLCOr1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Dec 2019 09:47:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575384445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V5hlEXhMWy4a4Vebks/KkRer4qhxJ474pIbf3LfOiko=;
        b=R50nGjKKVxBPZfEh91mti3I/k5wkI7604HNCSUCTA3z7MstKdThTA0hNVSF97aJEE/xUI6
        dD/CqQ8JiZpHdWHPC8k7pW6/yi2HoQMwliBNLSA3bcCxgGBgtZbeYOWej7R0VmOMj8Sr3O
        a55K4WrD8l+GEsR3BqgcEKj07ojKTPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-o9OJi9EyNSqSrNfMF_KnYQ-1; Tue, 03 Dec 2019 09:47:22 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66DB2801E7A;
        Tue,  3 Dec 2019 14:47:21 +0000 (UTC)
Received: from [10.72.12.69] (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6977D10842AD;
        Tue,  3 Dec 2019 14:47:15 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix mdsmap_decode got incorrect mds(X)
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191203142949.34910-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <088d2287-073e-eff7-a1cf-57cfa444a555@redhat.com>
Date:   Tue, 3 Dec 2019 22:47:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191203142949.34910-1-xiubli@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: o9OJi9EyNSqSrNfMF_KnYQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

This is the follow up of the previous series about the mdsmap.

The following the logs, we can see the first line there has only one MDS=20
with the rank number is mds(1):


<7>[116366.493705] ceph: mdsmap_decode 1/1 4343 mds1.17=20
(1)192.168.195.165:6814 up:active
<7>[116366.493711] ceph:=C2=A0 mdsmap_decode m_enabled: 1, m_damaged: 0,=20
m_num_laggy: 0
<7>[116366.493712] ceph:=C2=A0 mdsmap_decode success epoch 40
<7>[116366.567941] ceph:=C2=A0 mdsmap_decode 1/2 4343 mds1.17=20
(1)192.168.195.165:6814 up:active
<7>[116366.567947] ceph:=C2=A0 mdsmap_decode 2/2 4540 mds0.41=20
(1)192.168.195.165:6813 up:replay
<7>[116366.567950] ceph:=C2=A0 mdsmap_decode m_enabled: 1, m_damaged: 0,=20
m_num_laggy: 0
<7>[116366.567952] ceph:=C2=A0 mdsmap_decode success epoch 41
<6>[116366.567955] ceph: mds1 recovery completed
<7>[116367.576211] ceph:=C2=A0 mdsmap_decode 1/2 4343 mds1.17=20
(1)192.168.195.165:6814 up:active
<7>[116367.576215] ceph:=C2=A0 mdsmap_decode 2/2 4540 mds0.41=20
(1)192.168.195.165:6813 up:resolve
<7>[116367.576218] ceph:=C2=A0 mdsmap_decode m_enabled: 1, m_damaged: 0,=20
m_num_laggy: 0
<7>[116367.576219] ceph:=C2=A0 mdsmap_decode success epoch 42
<7>[116368.702161] ceph:=C2=A0 mdsmap_decode 1/2 4343 mds1.17=20
(1)192.168.195.165:6814 up:active
<7>[116368.702171] ceph:=C2=A0 mdsmap_decode 2/2 4540 mds0.41=20
(1)192.168.195.165:6813 up:reconnect
<7>[116368.702177] ceph:=C2=A0 mdsmap_decode m_enabled: 1, m_damaged: 0,=20
m_num_laggy: 0
<7>[116368.702180] ceph:=C2=A0 mdsmap_decode success epoch 43
<7>[116369.829235] ceph:=C2=A0 mdsmap_decode 1/2 4343 mds1.17=20
(1)192.168.195.165:6814 up:active
<7>[116369.829245] ceph:=C2=A0 mdsmap_decode 2/2 4540 mds0.41=20
(1)192.168.195.165:6813 up:rejoin
<7>[116369.829253] ceph:=C2=A0 mdsmap_decode m_enabled: 1, m_damaged: 0,=20
m_num_laggy: 0
<7>[116369.829255] ceph:=C2=A0 mdsmap_decode success epoch 44
<7>[116370.982653] ceph:=C2=A0 mdsmap_decode 1/2 4343 mds1.17=20
(1)192.168.195.165:6814 up:active
<7>[116370.982696] ceph:=C2=A0 mdsmap_decode 2/2 4540 mds0.41=20
(1)192.168.195.165:6813 up:active
<7>[116370.982785] ceph:=C2=A0 mdsmap_decode m_enabled: 1, m_damaged: 0,=20
m_num_laggy: 0
<7>[116370.982787] ceph:=C2=A0 mdsmap_decode success epoch 45

Thanks.
BRs

On 2019/12/3 22:29, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> The possible max rank, it maybe larger than the m->m_num_mds,
> for example if the mds_max =3D=3D 2 in the cluster, when the MDS(0)
> was laggy and being replaced by a new MDS, we will temporarily
> receive a new mds map with n_num_mds =3D=3D 1 and the active MDS(1),
> and the mds rank >=3D m->m_num_mds.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/mdsmap.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 284d68646c40..a77e0ecb9a6b 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -129,6 +129,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
>   =09int err;
>   =09u8 mdsmap_v, mdsmap_cv;
>   =09u16 mdsmap_ev;
> +=09u32 possible_max_rank;
>  =20
>   =09m =3D kzalloc(sizeof(*m), GFP_NOFS);
>   =09if (!m)
> @@ -164,6 +165,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, voi=
d *end)
>   =09m->m_num_mds =3D n =3D ceph_decode_32(p);
>   =09m->m_num_active_mds =3D m->m_num_mds;
>  =20
> +=09/*
> +=09 * the possible max rank, it maybe larger than the m->m_num_mds,
> +=09 * for example if the mds_max =3D=3D 2 in the cluster, when the MDS(0=
)
> +=09 * was laggy and being replaced by a new MDS, we will temporarily
> +=09 * receive a new mds map with n_num_mds =3D=3D 1 and the active MDS(1=
),
> +=09 * and the mds rank >=3D m->m_num_mds.
> +=09 */
> +=09possible_max_rank =3D max((u32)m->m_num_mds, m->m_max_mds);
> +
>   =09m->m_info =3D kcalloc(m->m_num_mds, sizeof(*m->m_info), GFP_NOFS);
>   =09if (!m->m_info)
>   =09=09goto nomem;
> @@ -238,7 +248,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
>   =09=09     ceph_mds_state_name(state),
>   =09=09     laggy ? "(laggy)" : "");
>  =20
> -=09=09if (mds < 0 || mds >=3D m->m_num_mds) {
> +=09=09if (mds < 0 || mds >=3D possible_max_rank) {
>   =09=09=09pr_warn("mdsmap_decode got incorrect mds(%d)\n", mds);
>   =09=09=09continue;
>   =09=09}


