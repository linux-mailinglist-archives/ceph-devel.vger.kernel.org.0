Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E652410C491
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2019 08:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfK1Hxm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Nov 2019 02:53:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54546 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726301AbfK1Hxl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 02:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574927620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DytCCKKmPRj3+5bTcMm9TgSaEobepi2wTUAw5EsEB4Y=;
        b=Xv24N6KEerrBK9XKSGq4rGy05e7vUK36SVMfmlEU2+1AgFgG2AcZT2mCiJysjti9ouRYot
        PoUAsvgyBrcgIwJ6m4fEaZkSEpHT2bueaWIn2tqhNHYIWkWUZ0DE20LbHLUebccwbF1+Hc
        plmjLE6hAarONHSBrsBpu8ZVgS0O8Ks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-CvoOeXHWMlOe7wjBQc_YrA-1; Thu, 28 Nov 2019 02:53:39 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D5BC10054E3;
        Thu, 28 Nov 2019 07:53:38 +0000 (UTC)
Received: from [10.72.12.69] (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBD23100164D;
        Thu, 28 Nov 2019 07:53:33 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: fix cap revoke race
To:     "Yan, Zheng" <zyan@redhat.com>, jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191127104549.33305-1-xiubli@redhat.com>
 <26da58b0-9e6a-70a8-641e-65b2c6ee075a@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <94793fb0-4527-7102-3529-074856c00db5@redhat.com>
Date:   Thu, 28 Nov 2019 15:53:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <26da58b0-9e6a-70a8-641e-65b2c6ee075a@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: CvoOeXHWMlOe7wjBQc_YrA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/28 10:25, Yan, Zheng wrote:
> On 11/27/19 6:45 PM, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The cap->implemented is one subset of the cap->issued, the logic
>> here want to exclude the revoking caps, but the following code
>> will be (~cap->implemented | cap->issued) =3D=3D 0xFFFF, so it will
>> make no sense when we doing the "have &=3D 0xFFFF".
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>> =C2=A0 fs/ceph/caps.c | 2 +-
>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index c62e88da4fee..a9335402c2a5 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -812,7 +812,7 @@ int __ceph_caps_issued(struct ceph_inode_info=20
>> *ci, int *implemented)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ci->i_auth_cap) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap =3D ci->i_aut=
h_cap;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 have &=3D ~cap->implemented =
| cap->issued;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 have &=3D ~(cap->implemented=
 & ~cap->issued);
>
> The end result is the same.
>
> See https://en.wikipedia.org/wiki/De_Morgan%27s_laws
>
Yeah, right, it is.

BRs



>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return have;
>> =C2=A0 }
>>
>

