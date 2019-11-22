Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E8C1066B2
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Nov 2019 07:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfKVG5B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Nov 2019 01:57:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58500 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726248AbfKVG5A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 Nov 2019 01:57:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574405819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ekoRj5aKR/GlVTJEafvU375X0vHXUs2/Iiy7OXjyRA4=;
        b=atk6oRnVxwvuI47B7SieP3LBdp8Q/dVhGvaMwC2cK0OPwLuUm4lc2mAtjUzYd6H/suB2YI
        LXdk4AMEP01cC7ksLkTuuBewElGKhfK5Nf0Th0o8cqutfbAxUBHVkZSsuiRBKIrgLrmJP1
        bmQaTn3wLp6/Cye2ZmeJolupm6tGjlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-Yg0baGgTNaGuzV6PDQcENw-1; Fri, 22 Nov 2019 01:56:58 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8124018C35A0;
        Fri, 22 Nov 2019 06:56:57 +0000 (UTC)
Received: from [10.72.12.58] (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 525B260159;
        Fri, 22 Nov 2019 06:56:52 +0000 (UTC)
Subject: Re: [PATCH 2/3] mdsmap: fix mdsmap cluster available check based on
 laggy number
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191120082902.38666-1-xiubli@redhat.com>
 <20191120082902.38666-3-xiubli@redhat.com>
 <52135037d9009f678e1b05964f0d6a1366a77ed0.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3fbcbc90-b323-5e8a-5664-fe8ce64a5100@redhat.com>
Date:   Fri, 22 Nov 2019 14:56:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <52135037d9009f678e1b05964f0d6a1366a77ed0.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Yg0baGgTNaGuzV6PDQcENw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/22 1:30, Jeff Layton wrote:
> On Wed, 2019-11-20 at 03:29 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In case the max_mds > 1 in MDS cluster and there is no any standby
>> MDS and all the max_mds MDSs are in up:active state, if one of the
>> up:active MDSs is dead, the m->m_num_laggy in kclient will be 1.
>> Then the mount will fail without considering other healthy MDSs.
>>
>> Only when all the MDSs in the cluster are laggy will treat the
>> cluster as not be available.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mdsmap.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>> index 471bac335fae..8b4f93e5b468 100644
>> --- a/fs/ceph/mdsmap.c
>> +++ b/fs/ceph/mdsmap.c
>> @@ -396,7 +396,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_md=
smap *m)
>>   =09=09return false;
>>   =09if (m->m_damaged)
>>   =09=09return false;
>> -=09if (m->m_num_laggy > 0)
>> +=09if (m->m_num_laggy =3D=3D m->m_num_mds)
>>   =09=09return false;
>>   =09for (i =3D 0; i < m->m_num_mds; i++) {
>>   =09=09if (m->m_info[i].state =3D=3D CEPH_MDS_STATE_ACTIVE)
> Given that laggy servers are still expected to be "in" the cluster,
> should we just eliminate this check altogether? It seems like we'd still
> want to allow a mount to occur even if the cluster is lagging.

For this we need one way to distinguish between mds crash and transient=20
mds laggy, for now in both cases the mds will keep staying "in" the=20
cluster and be in "up:active & laggy" state.



