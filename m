Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92547F86CB
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Nov 2019 03:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfKLCN4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Nov 2019 21:13:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24574 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726923AbfKLCNz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Nov 2019 21:13:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573524834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8porlPpJzaofE2ZdWqhd1j154EDvRdtkU321l4BnunI=;
        b=CnAEyALtHwyCFe+x8jbQyhZaRufqh5z7utoRj52JkgpnGXE7wVyuMoQLwCMrOvA7r5TRnW
        3lxUU1yoOh/BT4gvsmOCF/Q9x6kO6WQKBxo4vbKC9v8aGXdUbK9jQoHx+NhQ7bedU/3euq
        qxNFaZN+H0wxujEWfm+hgOgmTsP8bS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-uQDdNTrcN3S32lcsMgy46w-1; Mon, 11 Nov 2019 21:13:53 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01BDE1852E24;
        Tue, 12 Nov 2019 02:13:52 +0000 (UTC)
Received: from [10.72.12.180] (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D218C61F36;
        Tue, 12 Nov 2019 02:13:47 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix geting random mds from mdsmap
To:     Jeff Layton <jlayton@kernel.org>, sage@redhat.com,
        idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191111115105.58758-1-xiubli@redhat.com>
 <e5e82873c841d21c84658253d331c1ab04851dfa.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b59c0363-a65b-a3ab-c5c4-b9e12307c7b9@redhat.com>
Date:   Tue, 12 Nov 2019 10:13:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <e5e82873c841d21c84658253d331c1ab04851dfa.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: uQDdNTrcN3S32lcsMgy46w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/12 0:45, Jeff Layton wrote:
> On Mon, 2019-11-11 at 06:51 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For example, if we have 5 mds in the mdsmap and the states are:
>> m_info[5] --> [-1, 1, -1, 1, 1]
>>
>> If we get a ramdon number 1, then we should get the mds index 3 as
>> expected, but actually we will get index 2, which the state is -1.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mdsmap.c | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>> index ce2d00da5096..2011147f76bf 100644
>> --- a/fs/ceph/mdsmap.c
>> +++ b/fs/ceph/mdsmap.c
>> @@ -20,7 +20,7 @@
>>   int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
>>   {
>>   =09int n =3D 0;
>> -=09int i;
>> +=09int i, j;
>>  =20
>>   =09/* special case for one mds */
>>   =09if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0)
>> @@ -35,9 +35,12 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
>>  =20
>>   =09/* pick */
>>   =09n =3D prandom_u32() % n;
>> -=09for (i =3D 0; n > 0; i++, n--)
>> -=09=09while (m->m_info[i].state <=3D 0)
>> -=09=09=09i++;
>> +=09for (j =3D 0, i =3D 0; i < m->m_num_mds; i++) {
>> +=09=09if (m->m_info[0].state > 0)
>> +=09=09=09j++;
>> +=09=09if (j > n)
>> +=09=09=09break;
>> +=09}
>>  =20
>>   =09return i;
>>   }
> Looks good. I'll merge after some testing.
>
> Took me a minute but the crux of the issue is that the for loop
> increment gets done regardless of the outcome of the while loop test.

Yeah, in another case when there has only one mds is up and if=20
'm_num_mds > 1', such as [-1, 1, -1], so after `n =3D prandom_u32() % n`,=
=20
the 'n' would always be 0. Then the 'for' and 'while' loops wouldn't=20
have any chance to run and the 'i' would always be 0 and be returned.


> This looks nicer too. I don't think it's actually possible, but the
> while loop _looks_ like it could walk off the end of the array.

 From my following test cases the 'while' loop seemed won't walk off the=20
end of the array because the 'n > 0' in the 'for' loop would help guard it.

[1, 1, 1, -1, -1, -1]

[-1, 1, -1, -1]

...

The fix here will just skip the MDSs whose states are down and until we=20
have count enough MDSs in up state.


Thanks

BRs


> Thanks,


