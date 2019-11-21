Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6580104DBC
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 09:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKUIUF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 03:20:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53214 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726014AbfKUIUF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Nov 2019 03:20:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574324403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l72+B+qRVKDK9OTsyZDZ8ePsGlTm5/5r8DYhhnf1+1k=;
        b=hmitmYE4z+hg8JrWeJVpGt0svAxBbsX6VTLSR8+1yo5yUdyIphtUDaZG1AWIQlkU97Qrad
        JTv6XJc7infrndfkhMob9VMRGwBUtUKfWWpf107XakXcGzQmnJUDZcOlCylrMPM/lxFEiZ
        itLV6CApxgQCdyB7BoKXiXrJNrreacY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-MAS0D3FRNmau1nsGhfnlVQ-1; Thu, 21 Nov 2019 03:19:59 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91E0D107ACC5;
        Thu, 21 Nov 2019 08:19:58 +0000 (UTC)
Received: from [10.72.12.118] (ovpn-12-118.pek2.redhat.com [10.72.12.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8F756CE54;
        Thu, 21 Nov 2019 08:19:52 +0000 (UTC)
Subject: Re: [PATCH 3/3] mdsmap: only choose one MDS who is in up:active state
 without laggy
To:     Xiubo Li <xiubli@redhat.com>, jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191120082902.38666-1-xiubli@redhat.com>
 <20191120082902.38666-4-xiubli@redhat.com>
 <bd733875-f491-ea06-335a-e2856a76dea8@redhat.com>
 <ccfdef0b-a2ac-bd79-f803-6764370c3c97@redhat.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <3fe815c0-962b-2827-45a9-d21b34825e3b@redhat.com>
Date:   Thu, 21 Nov 2019 16:19:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <ccfdef0b-a2ac-bd79-f803-6764370c3c97@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: MAS0D3FRNmau1nsGhfnlVQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/21/19 1:24 PM, Xiubo Li wrote:
> On 2019/11/21 10:46, Yan, Zheng wrote:
>> On 11/20/19 4:29 PM, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Even the MDS is in up:active state, but it also maybe laggy. Here
>>> will skip the laggy MDSs.
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>> =C2=A0 fs/ceph/mds_client.c |=C2=A0 6 ++++--
>>> =C2=A0 fs/ceph/mdsmap.c=C2=A0=C2=A0=C2=A0=C2=A0 | 13 +++++++++----
>>> =C2=A0 2 files changed, 13 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index 82a929084671..a4e7026aaec9 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -972,7 +972,8 @@ static int __choose_mds(struct ceph_mds_client=20
>>> *mdsc,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 frag.frag, =
mds,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (int)r, fra=
g.ndist);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ceph_mdsmap_get_state(mdsc->mdsmap, m=
ds) >=3D
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CEPH_MDS_STATE_ACTIVE)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CEPH_MDS_STATE_ACTIVE &&
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !ceph_mdsmap_is_laggy(mdsc->m=
dsmap, mds))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
>>> =C2=A0 @@ -987,7 +988,8 @@ static int __choose_mds(struct ceph_mds_clie=
nt=20
>>> *mdsc,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "frag %u md=
s%d (auth)\n",
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode, ceph=
_vinop(inode), frag.frag, mds);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ceph_mdsmap_get_state(mdsc->mdsmap, m=
ds) >=3D
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CEPH_MDS_STATE_ACTIVE)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CEPH_MDS_STATE_ACTIVE &&
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !ceph_mdsmap_is_laggy(mdsc->m=
dsmap, mds))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> for use USE_AUTH_MDS case, request can only be handled by auth mds.=20
>> client should send request to auth mds even it seems laggy.
>>
> BTW, what if the coreesponding auth mds was down, will it allow to=20
> choose other mds ? From the current code it seems might. Or as long as=20
> when the corresponding auth mds is in up:active state will the requests=
=20
> only could to be handled by it ?
>=20

Some requests can only be handled by given MDS. Choosing other mds just=20
wastes resource.



> Thanks.
>=20
>=20
>>
>>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>>> index 8b4f93e5b468..098669e6f1e4 100644
>>> --- a/fs/ceph/mdsmap.c
>>> +++ b/fs/ceph/mdsmap.c
>>> @@ -13,6 +13,7 @@
>>> =C2=A0 =C2=A0 #include "super.h"
>>> =C2=A0 +#define CEPH_MDS_IS_READY(i) (m->m_info[i].state > 0 &&=20
>>> !m->m_info[i].laggy)
>>> =C2=A0 =C2=A0 /*
>>> =C2=A0=C2=A0 * choose a random mds that is "up" (i.e. has a state > 0),=
 or -1.
>>> @@ -23,12 +24,16 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap=
=20
>>> *m)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i, j;
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* special case for one mds */
>>> -=C2=A0=C2=A0=C2=A0 if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0=
)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> +=C2=A0=C2=A0=C2=A0 if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0=
) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (m->m_info[0].laggy)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
urn -1;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
urn 0;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* count */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < m->m_num_mds; i++)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (m->m_info[i].state > 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (CEPH_MDS_IS_READY(i))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 n++;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (n =3D=3D 0)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>>> @@ -36,7 +41,7 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* pick */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 n =3D prandom_u32() % n;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (j =3D 0, i =3D 0; i < m->m_num_mds;=
 i++) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (m->m_info[i].state > 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (CEPH_MDS_IS_READY(i))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 j++;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (j > n)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 break;
>>>
>>
>=20

