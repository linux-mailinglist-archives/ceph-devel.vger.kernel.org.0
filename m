Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD1A1048A8
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 03:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfKUCnB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Nov 2019 21:43:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43146 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725819AbfKUCnB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Nov 2019 21:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574304179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EjuOgHAkc7b3rChT/TegFJsPBw42qpRe+5VcCGr3k14=;
        b=GpBvrIYCaoN/dlLNuJbv8XAbiNI4rZd+eDL/8mcTE6j/lENY4/jIjJ+j7itLVWqnJBi7ln
        oYp/5ue+99S2tY7mZWHsC8ax3Liou44hB5WbsA73NvOSB3kMDPwgqo+rlGGRbFoQoODb8L
        yUZsmuEeBxigEuIY3uOWZ4uWt0iA2uk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-iclu_X-2PK2pTKpSlQXe9Q-1; Wed, 20 Nov 2019 21:42:58 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B235477;
        Thu, 21 Nov 2019 02:42:57 +0000 (UTC)
Received: from [10.72.12.177] (ovpn-12-177.pek2.redhat.com [10.72.12.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C6CF106F96F;
        Thu, 21 Nov 2019 02:42:51 +0000 (UTC)
Subject: Re: [PATCH 0/3] mdsmap: fix mds choosing
To:     Jeff Layton <jlayton@kernel.org>, xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191120082902.38666-1-xiubli@redhat.com>
 <23c18302b3b9e730e304fde39d07477ef29faf1c.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <f43d582a-5ca5-2f69-7d0e-792665367e83@redhat.com>
Date:   Thu, 21 Nov 2019 10:42:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <23c18302b3b9e730e304fde39d07477ef29faf1c.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: iclu_X-2PK2pTKpSlQXe9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/20/19 9:50 PM, Jeff Layton wrote:
> On Wed, 2019-11-20 at 03:28 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Xiubo Li (3):
>>    mdsmap: add more debug info when decoding
>>    mdsmap: fix mdsmap cluster available check based on laggy number
>>    mdsmap: only choose one MDS who is in up:active state without laggy
>>
>>   fs/ceph/mds_client.c |  6 ++++--
>>   fs/ceph/mdsmap.c     | 27 ++++++++++++++++++---------
>>   2 files changed, 22 insertions(+), 11 deletions(-)
>>
>=20
> These all look good to me. I'll plan to merge them for v5.5, unless
> anyone else sees issues with them.
>=20
> Thanks!
>=20

Main problem of this series is that we need to distinguish between mds=20
crash and transient mds laggy.

