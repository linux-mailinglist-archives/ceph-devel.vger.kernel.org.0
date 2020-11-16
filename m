Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4119A2B3C24
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Nov 2020 05:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgKPEeX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 15 Nov 2020 23:34:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbgKPEeW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 15 Nov 2020 23:34:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605501261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zAmt9Z8dm4ZTHu67uWVMbdrestxnaTPMTqIP7FyomZw=;
        b=SiJfRuZVw9HWj4H91UHhMOrfR4qVU+irM3DfC7y9iD3vKl5zuVyn+sa6x8TbhUlv6yMbOr
        Zbpy1Mrncqi+SClYED14RI3aN2mHUDz5uK6Z5gojgfJD+b1w194X57XbGKpeUSnaqqhK54
        iSCv157oC1DhP/RHV+qENKloWEQx8MI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-tsg3Bm2DNnuraNr5LvdYRw-1; Sun, 15 Nov 2020 23:34:18 -0500
X-MC-Unique: tsg3Bm2DNnuraNr5LvdYRw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44E7F1074658;
        Mon, 16 Nov 2020 04:34:17 +0000 (UTC)
Received: from [10.72.13.29] (ovpn-13-29.pek2.redhat.com [10.72.13.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 623F85C5B7;
        Mon, 16 Nov 2020 04:34:15 +0000 (UTC)
Subject: Re: [PATCH v3 1/2] ceph: add status debug file support
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201110141703.414211-1-xiubli@redhat.com>
 <20201110141703.414211-2-xiubli@redhat.com>
 <CA+2bHPZfW8+zEuhxjxJ8dJzj70u2LGvKcxhOnGOXM9sjK_oSTQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3ee816ed-c2ea-5c2a-fb07-0f35c61b7ad2@redhat.com>
Date:   Mon, 16 Nov 2020 12:34:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <CA+2bHPZfW8+zEuhxjxJ8dJzj70u2LGvKcxhOnGOXM9sjK_oSTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/14 3:42, Patrick Donnelly wrote:
> On Tue, Nov 10, 2020 at 6:17 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will help list some useful client side info, like the client
>> entity address/name and bloclisted status, etc.
>>
>> URL: https://tracker.ceph.com/issues/48057
> Thanks for working on this Xiubo. Do we have an Ceph PR for updating
> the QA bits to use this?
>
Not yet. I will raise one.

Thanks

