Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2836109CF9
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 12:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfKZLZi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 06:25:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49273 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727218AbfKZLZi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Nov 2019 06:25:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574767537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UFDrziayu2pkQq9QZ+i8yxnEoV1kjqMkfP20K2DSD/o=;
        b=Q3nc2Zj0qPYMkyKxkqMseuc79h81+CoYpW2cmbugwd5D6xpSZIYTc7Mx4rVG4BpYRaAlT1
        aJy+77WxcRG/ducz7JbmZqZhT80GeBts3efF0w25iNkRBbXFZiTulDAf/AM7MUOsbHUZdf
        gniNnXl4GggZPRtU6GkS4Cb20xqoUVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-mLJdmHQYMlSLEjFDkuXYYA-1; Tue, 26 Nov 2019 06:25:34 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40BB9800591;
        Tue, 26 Nov 2019 11:25:33 +0000 (UTC)
Received: from [10.72.12.66] (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D1285D9D6;
        Tue, 26 Nov 2019 11:25:25 +0000 (UTC)
Subject: Re: [PATCH] ceph: trigger the reclaim work once there has enough
 pending caps
To:     "Yan, Zheng" <zyan@redhat.com>, "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20191126085114.40326-1-xiubli@redhat.com>
 <CAAM7YA=SAY-DQ5iUB-837=eC-ERV46_1_6Zi4SLNdD13_x4U4A@mail.gmail.com>
 <b0714ccd-4844-4b3e-24d4-d75e10bb6b08@redhat.com>
 <62d6459b-f227-64c9-482b-80148bdea696@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f215a5ce-f71a-4811-3650-5d62ec00262d@redhat.com>
Date:   Tue, 26 Nov 2019 19:25:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <62d6459b-f227-64c9-482b-80148bdea696@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: mLJdmHQYMlSLEjFDkuXYYA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/26 19:03, Yan, Zheng wrote:
> On 11/26/19 6:01 PM, Xiubo Li wrote:
>> On 2019/11/26 17:49, Yan, Zheng wrote:
>>> On Tue, Nov 26, 2019 at 4:57 PM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The nr in ceph_reclaim_caps_nr() is very possibly larger than 1,
>>>> so we may miss it and the reclaim work couldn't triggered as expected.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>> =C2=A0 fs/ceph/mds_client.c | 2 +-
>>>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index 08b70b5ee05e..547ffe16f91c 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct=20
>>>> ceph_mds_client *mdsc, int nr)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!nr)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val =3D atomic_add_re=
turn(nr, &mdsc->cap_reclaim_pending);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(val % CEPH_CAPS_PER_RELEAS=
E)) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (val / CEPH_CAPS_PER_RELEASE)=
 {
>>>> atomic_set(&mdsc->cap_reclaim_pending, 0);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_queue_cap_reclaim_work(mdsc);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> this will call ceph_queue_cap_reclaim_work too frequently
>>
>> No it won't, the '/' here equals to '>=3D' and then the=20
>> "mdsc->cap_reclaim_pending" will be reset and it will increase from 0=20
>> again.
>>
>> It will make sure that only when "mdsc->cap_reclaim_pending >=3D=20
>> CEPH_CAPS_PER_RELEASE" will call the work queue.
>
> Work does not get executed immediately. call=20
> ceph_queue_cap_reclaim_work() when val =3D=3D CEPH_CAPS_PER_RELEASE is=20
> enough. There is no point to call it too frequently
>
>
Yeah, it true and I am okay with this. Just going through the session=20
release related code, and saw the "nr" parameter will be "ctx->used" in=20
ceph_reclaim_caps_nr(mdsc, ctx->used), and in case there has many=20
sessions with tremendous amount of caps. In corner case that we may=20
always miss the condition that the "val =3D=3D CEPH_CAPS_PER_RELEASE" here.

IMO, it wants to fire the work queue once "val >=3D=20
CEPH_CAPS_PER_RELEASE", but it is not working like this, the val may=20
just skip it without doing any thing.

Thanks


>>
>>>> --=20
>>>> 2.21.0
>>>>
>>
>

