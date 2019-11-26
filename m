Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EA3109CB2
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 12:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfKZLDy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 06:03:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26437 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727771AbfKZLDx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Nov 2019 06:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574766232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JGhcWfyebmNuTEFEjEq8eMMkTU2XMrgWmhZfz8O151s=;
        b=BprpVLnEGU3yeHPqc2qdugJBhtUm4bGFFmD1HtGr7huhkzdQ4xX0LeTbC3ihITzGZshbo0
        KfVZVKeR8GlncZE1CA5riCrIst6ByE5qK+DMsbI1Qe1c4+csuF5Sw9P+UigWEV9QYlyn5I
        g/0ZDetpGezZXNKHjIJgXzhRJRFH5bo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-mf3YkyY2PXa4zwCLLNxr8A-1; Tue, 26 Nov 2019 06:03:50 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ABF1593A2;
        Tue, 26 Nov 2019 11:03:49 +0000 (UTC)
Received: from [10.72.12.92] (ovpn-12-92.pek2.redhat.com [10.72.12.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 310015D6BE;
        Tue, 26 Nov 2019 11:03:42 +0000 (UTC)
Subject: Re: [PATCH] ceph: trigger the reclaim work once there has enough
 pending caps
To:     Xiubo Li <xiubli@redhat.com>, "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20191126085114.40326-1-xiubli@redhat.com>
 <CAAM7YA=SAY-DQ5iUB-837=eC-ERV46_1_6Zi4SLNdD13_x4U4A@mail.gmail.com>
 <b0714ccd-4844-4b3e-24d4-d75e10bb6b08@redhat.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <62d6459b-f227-64c9-482b-80148bdea696@redhat.com>
Date:   Tue, 26 Nov 2019 19:03:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b0714ccd-4844-4b3e-24d4-d75e10bb6b08@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: mf3YkyY2PXa4zwCLLNxr8A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/26/19 6:01 PM, Xiubo Li wrote:
> On 2019/11/26 17:49, Yan, Zheng wrote:
>> On Tue, Nov 26, 2019 at 4:57 PM <xiubli@redhat.com> wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> The nr in ceph_reclaim_caps_nr() is very possibly larger than 1,
>>> so we may miss it and the reclaim work couldn't triggered as expected.
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>> =C2=A0 fs/ceph/mds_client.c | 2 +-
>>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index 08b70b5ee05e..547ffe16f91c 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct=20
>>> ceph_mds_client *mdsc, int nr)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!nr)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val =3D atomic_add_ret=
urn(nr, &mdsc->cap_reclaim_pending);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(val % CEPH_CAPS_PER_RELEASE=
)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (val / CEPH_CAPS_PER_RELEASE) =
{
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_set(&mdsc->cap_reclaim_pending, 0);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_queue_cap_reclaim_work(mdsc);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> this will call ceph_queue_cap_reclaim_work too frequently
>=20
> No it won't, the '/' here equals to '>=3D' and then the=20
> "mdsc->cap_reclaim_pending" will be reset and it will increase from 0=20
> again.
>=20
> It will make sure that only when "mdsc->cap_reclaim_pending >=3D=20
> CEPH_CAPS_PER_RELEASE" will call the work queue.

Work does not get executed immediately. call=20
ceph_queue_cap_reclaim_work() when val =3D=3D CEPH_CAPS_PER_RELEASE is=20
enough. There is no point to call it too frequently


>=20
>>> --=20
>>> 2.21.0
>>>
>=20

