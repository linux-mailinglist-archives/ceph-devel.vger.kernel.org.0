Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52124109713
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 00:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKYXtA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Nov 2019 18:49:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29908 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725912AbfKYXs7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Nov 2019 18:48:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574725738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKA3MWR69hii7C5F098jK0Wuw80UKbSOb5g88PQQfPA=;
        b=XXWS6a84+fw00K0Ip+3H+AZ370r8bNeTICbzYmU/0gpi9TosjfW/tYsLHRh56tMia8PeoN
        ra6sa8G+hBmxUhIPDT2jp6rVRWnVq4O2VWQ1Pnn4gq4q0M/EkN/6zWs+SdXv7YT9EIOu0O
        QRbno8XskMIEm1rubQ2/WI0yMTafDyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-Kw0SY3dkPNuWe4pQ4dGjGw-1; Mon, 25 Nov 2019 18:48:54 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D98B4801437;
        Mon, 25 Nov 2019 23:48:53 +0000 (UTC)
Received: from [10.72.12.66] (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA31D60BE2;
        Mon, 25 Nov 2019 23:48:48 +0000 (UTC)
Subject: Re: [PATCH v2 2/3] mdsmap: fix mdsmap cluster available check based
 on laggy number
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191125110827.12827-1-xiubli@redhat.com>
 <20191125110827.12827-3-xiubli@redhat.com>
 <3cbf12af7e05ea711e376ddbf93be5abf84fbf00.camel@kernel.org>
 <7e9ebebf-10b2-76e4-ae5f-cbdde25061f1@redhat.com>
 <49bdbfbaab4d2080a045da0678d760880888c85b.camel@kernel.org>
 <2fa10816-3e24-39ef-1d94-5503debfc5ed@redhat.com>
Message-ID: <25381285-a01e-ab32-ad31-d16b6d0bfb76@redhat.com>
Date:   Tue, 26 Nov 2019 07:48:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <2fa10816-3e24-39ef-1d94-5503debfc5ed@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: Kw0SY3dkPNuWe4pQ4dGjGw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/26 7:25, Xiubo Li wrote:
> On 2019/11/26 1:22, Jeff Layton wrote:
>> On Mon, 2019-11-25 at 21:50 +0800, Xiubo Li wrote:
>>> On 2019/11/25 21:27, Jeff Layton wrote:
>>>> On Mon, 2019-11-25 at 06:08 -0500, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> In case the max_mds > 1 in MDS cluster and there is no any standby
>>>>> MDS and all the max_mds MDSs are in up:active state, if one of the
>>>>> up:active MDSs is dead, the m->m_num_laggy in kclient will be 1.
>>>>> Then the mount will fail without considering other healthy MDSs.
>>>>>
>>>>> There manybe some MDSs still "in" the cluster but not in up:active
>>>>> state, we will ignore them. Only when all the up:active MDSs in
>>>>> the cluster are laggy will treat the cluster as not be available.
>>>>>
>>>>> In case decreasing the max_mds, the cluster will not stop the extra
>>>>> up:active MDSs immediately and there will be a latency. During it
>>>>> the up:active MDS number will be larger than the max_mds, so later
>>>>> the m_info memories will 100% be reallocated.
>>>>>
>>>>> Here will pick out the up:active MDSs as the m_num_mds and allocate
>>>>> the needed memories once.
>>>>>
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>> =C2=A0=C2=A0 fs/ceph/mdsmap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 32 ++++++++++----------------------
>>>>> =C2=A0=C2=A0 include/linux/ceph/mdsmap.h |=C2=A0 5 +++--
>>>>> =C2=A0=C2=A0 2 files changed, 13 insertions(+), 24 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>>>>> index 471bac335fae..cc9ec959fe46 100644
>>>>> --- a/fs/ceph/mdsmap.c
>>>>> +++ b/fs/ceph/mdsmap.c
>>>>> @@ -138,14 +138,21 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void=20
>>>>> **p, void *end)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 m->m_session_autoclose =3D ceph_=
decode_32(p);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 m->m_max_file_size =3D ceph_deco=
de_64(p);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 m->m_max_mds =3D ceph_decode_32(=
p);
>>>>> -=C2=A0=C2=A0=C2=A0 m->m_num_mds =3D m->m_max_mds;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * pick out the active nodes as the m_num_md=
s, the m_num_mds
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * maybe larger than m_max_mds when decreasi=
ng the max_mds in
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * cluster side, in other case it should les=
s than or equal
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * to m_max_mds.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> +=C2=A0=C2=A0=C2=A0 m->m_num_mds =3D n =3D ceph_decode_32(p);
>>>>> +=C2=A0=C2=A0=C2=A0 m->m_num_active_mds =3D m->m_num_mds;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 m->m_info =3D kcall=
oc(m->m_num_mds, sizeof(*m->m_info),=20
>>>>> GFP_NOFS);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!m->m_info)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto nom=
em;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* pick out active =
nodes from mds_info (state > 0) */
>>>>> -=C2=A0=C2=A0=C2=A0 n =3D ceph_decode_32(p);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < n; i++) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 glob=
al_id;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 name=
len;
>>>>> @@ -218,17 +225,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void=20
>>>>> **p, void *end)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mds =
< 0 || state <=3D 0)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 continue;
>>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mds >=3D=
 m->m_num_mds) {
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
nt new_num =3D max(mds + 1, m->m_num_mds * 2);
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 v=
oid *new_m_info =3D krealloc(m->m_info,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ne=
w_num * sizeof(*m->m_info),
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GF=
P_NOFS | __GFP_ZERO);
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (!new_m_info)
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto nomem;
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 m=
->m_info =3D new_m_info;
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 m=
->m_num_mds =3D new_num;
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> -
>>>> I don't think we want to get rid of this bit. What happens if the=20
>>>> number
>>>> of MDS' increases after the mount occurs?
>>> Every time when we receive a new version of mdsmap, the old whole
>>> mdsc->mdsmap memory will be reallocated and replaced, no matter the=20
>>> MDS'
>>> increases or decreases.
>>>
>>> The active nodes from mds_info above will help record the actual MDS
>>> number and then we decode it into "m_num_active_mds". If we are
>>> decreasing the max_mds in the cluster side, the "m_num_active_mds" will
>>> very probably be larger than the expected "m_num_mds", then we
>>> definitely will need to reallocate the memory for m->m_info here. Why
>>> not allocate enough memory beforehand ?
>>>
>>> BTW, from my investigation that the mds number decoded from the=20
>>> mds_info
>>> won't be larger than the "m_num_active_mds". If I am right then this
>>> code is useless here, or we need it.
>>>
>> It shouldn't be larger than that, but...the "mds" value is decoded from
>> the map and gets treated as an index into the m_info array. If that
>> value ends up being larger than the array you initially allocated, then
>> we're looking at a buffer overrun.
>>
>> I don't think we should trust the consistency of the info in the map to
>> that degree, so we either need to keep something like the reallocation
>> in place, or add some sanity checks to make sure that that possibility
>> is handled sanely.
>
In case of mds >=3D m->m_num_mds, the consistency maybe corrupt or=20
something is indeed wrong, then the mds maybe very larger than expected,=20
then I am thinking whether is the reallocation is sane ? Or we'd better=20
just skip it with some warning messages ?


> Okay, then let keep this code to do the sanity check.
>
>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info =3D=
 &m->m_info[mds];
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info->gl=
obal_id =3D global_id;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info->st=
ate =3D state;
>>>>> @@ -247,14 +243,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void=20
>>>>> **p, void *end)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 info->export_targets =3D NULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> -=C2=A0=C2=A0=C2=A0 if (m->m_num_mds > m->m_max_mds) {
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* find max up mds */
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D m->m_num_mds; =
i >=3D m->m_max_mds; i--) {
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (i =3D=3D 0 || m->m_info[i-1].state > 0)
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 m->m_num_mds =3D i;
>>>>> -=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* pg_pools */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_decode_32_safe(p, end, n, b=
ad);
>>>>> @@ -396,7 +384,7 @@ bool ceph_mdsmap_is_cluster_available(struct=20
>>>>> ceph_mdsmap *m)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return f=
alse;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (m->m_damaged)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return f=
alse;
>>>>> -=C2=A0=C2=A0=C2=A0 if (m->m_num_laggy > 0)
>>>>> +=C2=A0=C2=A0=C2=A0 if (m->m_num_laggy =3D=3D m->m_num_active_mds)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return f=
alse;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < m->m_num_mds; =
i++) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (m->m=
_info[i].state =3D=3D CEPH_MDS_STATE_ACTIVE)
>>>>> diff --git a/include/linux/ceph/mdsmap.h=20
>>>>> b/include/linux/ceph/mdsmap.h
>>>>> index 0067d767c9ae..3a66f4f926ce 100644
>>>>> --- a/include/linux/ceph/mdsmap.h
>>>>> +++ b/include/linux/ceph/mdsmap.h
>>>>> @@ -25,8 +25,9 @@ struct ceph_mdsmap {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 m_session_timeout;=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* seconds */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 m_session_autoclose;=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* seconds */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 m_max_file_size;
>>>>> -=C2=A0=C2=A0=C2=A0 u32 m_max_mds;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* si=
ze of m_addr, m_state=20
>>>>> arrays */
>>>>> -=C2=A0=C2=A0=C2=A0 int m_num_mds;
>>>>> +=C2=A0=C2=A0=C2=A0 u32 m_max_mds;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* expected up:active mds number */
>>>>> +=C2=A0=C2=A0=C2=A0 int m_num_active_mds;=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /* actual up:active mds number */
>>>>> +=C2=A0=C2=A0=C2=A0 int m_num_mds;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* si=
ze of m_info array */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_mds_info *m_info;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* which object poo=
ls file data can be stored in */
>>>
>

