Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EE52B2A2B
	for <lists+ceph-devel@lfdr.de>; Sat, 14 Nov 2020 01:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgKNAye (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Nov 2020 19:54:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbgKNAye (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 19:54:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605315273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eq2cmAbCIaZ5gfOV5N98zjHPb6N9xIncXtZ5ayQw+OQ=;
        b=dxyYKo+wlIhEP8MEfMJ6bas/wIgJV+D6oiAsXfMlkBe85ww2uOXIILzn1rO2f136SaqvFu
        GyHFPrHFOPMVy6Fla5eeWnIDeVmjmwQs/nQ8bCI2Vl+Y+JRxu2AMk6a5RVHFUEE0xhN7Y9
        nOr6BY7WyTjKpg5a08yxibIhucr/v1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-ZxOXX4Q0PM-KIa0f61zecw-1; Fri, 13 Nov 2020 19:54:31 -0500
X-MC-Unique: ZxOXX4Q0PM-KIa0f61zecw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0D2E420FE;
        Sat, 14 Nov 2020 00:54:30 +0000 (UTC)
Received: from [10.72.12.65] (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5CCE62665;
        Sat, 14 Nov 2020 00:54:28 +0000 (UTC)
Subject: Re: [PATCH v4 2/2] ceph: add ceph.{cluster_fsid/client_id} vxattrs
 suppport
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201111012940.468289-1-xiubli@redhat.com>
 <20201111012940.468289-3-xiubli@redhat.com>
 <CA+2bHPZuXcVw6Mwpz0wkg-SDsUc7XZqK0_m2eVQsQOEsQkZiGw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f7cb5221-68c5-7bca-7c48-4021823e4c04@redhat.com>
Date:   Sat, 14 Nov 2020 08:54:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <CA+2bHPZuXcVw6Mwpz0wkg-SDsUc7XZqK0_m2eVQsQOEsQkZiGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/14 3:40, Patrick Donnelly wrote:
> On Tue, Nov 10, 2020 at 5:29 PM <xiubli@redhat.com> wrote:
[...]
>>   static struct ceph_vxattr *ceph_inode_vxattrs(struct inode *inode)
>>   {
>>          if (S_ISDIR(inode->i_mode))
>> @@ -429,6 +464,13 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
>>                  }
>>          }
>>
>> +       vxattr = ceph_common_vxattrs;
>> +       while (vxattr->name) {
>> +               if (!strcmp(vxattr->name, name))
>> +                       return vxattr;
>> +               vxattr++;
>> +       }
>> +
>>          return NULL;
>>   }
> Please also be sure to wire up the same vxattrs in the userspace Client.
>
>
Sure, will do.

Thanks.

