Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DD5105160
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 12:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKUL2P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 06:28:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26076 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726165AbfKUL2P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Nov 2019 06:28:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574335694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RFxkZ6hMwBOESROXFxNEa3Qen9DfueggDooDbslxoF4=;
        b=hOARsqN5bUUkpxU6lD6LBS7cS86x/VCYiEi91dCZ/V0ttT2iTCtdc9uVpYFSLTb1vTgTWH
        wydK3V61hLWjuupNaJpDpbJYfSDCvqN3VmNwIyapLLOynoyTRApvVTX2o9ux3e2qAu7HdN
        thDdOLbARuD9o7WbUsGDoPj2li5l8tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-HHY7to8XOVSrHDv0YlbGig-1; Thu, 21 Nov 2019 06:28:13 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30386100729E;
        Thu, 21 Nov 2019 11:28:12 +0000 (UTC)
Received: from [10.72.12.58] (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68BF260C23;
        Thu, 21 Nov 2019 11:28:06 +0000 (UTC)
Subject: Re: [PATCH 0/3] mdsmap: fix mds choosing
To:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191120082902.38666-1-xiubli@redhat.com>
 <23c18302b3b9e730e304fde39d07477ef29faf1c.camel@kernel.org>
 <f43d582a-5ca5-2f69-7d0e-792665367e83@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f3a54240-b18c-064b-cd9a-1ec64202798a@redhat.com>
Date:   Thu, 21 Nov 2019 19:28:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <f43d582a-5ca5-2f69-7d0e-792665367e83@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: HHY7to8XOVSrHDv0YlbGig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/21 10:42, Yan, Zheng wrote:
> On 11/20/19 9:50 PM, Jeff Layton wrote:
>> On Wed, 2019-11-20 at 03:28 -0500, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Xiubo Li (3):
>>> =C2=A0=C2=A0 mdsmap: add more debug info when decoding
>>> =C2=A0=C2=A0 mdsmap: fix mdsmap cluster available check based on laggy =
number
>>> =C2=A0=C2=A0 mdsmap: only choose one MDS who is in up:active state with=
out laggy
>>>
>>> =C2=A0 fs/ceph/mds_client.c |=C2=A0 6 ++++--
>>> =C2=A0 fs/ceph/mdsmap.c=C2=A0=C2=A0=C2=A0=C2=A0 | 27 ++++++++++++++++++=
---------
>>> =C2=A0 2 files changed, 22 insertions(+), 11 deletions(-)
>>>
>>
>> These all look good to me. I'll plan to merge them for v5.5, unless
>> anyone else sees issues with them.
>>
>> Thanks!
>>
>
> Main problem of this series is that we need to distinguish between mds=20
> crash and transient mds laggy.

How about let's try to check and get an up:active & !laggy mds first, if=20
we couldn't find one then fall back to one that is up:active & laggy ?

For the auth mds case, we will ignore the laggy stuff.


BRs

