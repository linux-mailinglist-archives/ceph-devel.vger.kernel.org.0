Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8998E17447C
	for <lists+ceph-devel@lfdr.de>; Sat, 29 Feb 2020 03:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgB2CeW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 21:34:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21075 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726046AbgB2CeW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 28 Feb 2020 21:34:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582943659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wi/TQr5v9SSVNXvF3/zrU8UMq5HDm0Am5tzZx/A0EFc=;
        b=cC3u1XDjqyaFyVjpoyt4zO6jyxRTpDO+dTN+8S6sve+iFItsaF1UO1sflKoDLjCWnmhp8F
        Q0rMlVYIcuu7D+ptegWGQfdgyLuRPeVlk4vtJGLi6tf1XaPHYHcWtlRMOaVyfargm3xfKD
        8OPZ6ervywWzktwYq/mRJUYYd78TJoo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-6vFUMY3WMnmPAgyTtd6-3A-1; Fri, 28 Feb 2020 21:34:17 -0500
X-MC-Unique: 6vFUMY3WMnmPAgyTtd6-3A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B11A800D48;
        Sat, 29 Feb 2020 02:34:16 +0000 (UTC)
Received: from [10.72.12.55] (ovpn-12-55.pek2.redhat.com [10.72.12.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 348E960BF1;
        Sat, 29 Feb 2020 02:34:14 +0000 (UTC)
Subject: Re: unsafe list walking in __kick_flushing_caps?
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <4a4d32dc5c4a44cca4ed31bb66d9cfcb0b1092c7.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <30fddf35-49ff-3009-f6a8-fd4ea6c65e05@redhat.com>
Date:   Sat, 29 Feb 2020 10:34:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <4a4d32dc5c4a44cca4ed31bb66d9cfcb0b1092c7.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2/29/20 5:39 AM, Jeff Layton wrote:
> Hi Zheng,
> 
> I've been going over the cap handling code, and noticed some sketchy
> looking locking in __kick_flushing_caps that was added by this patch:
> 
> 
> commit e4500b5e35c213e0f97be7cb69328c0877203a79
> Author: Yan, Zheng <zyan@redhat.com>
> Date:   Wed Jul 6 11:12:56 2016 +0800
> 
>      ceph: use list instead of rbtree to track cap flushes
>      
>      We don't have requirement of searching cap flush by TID. In most cases,
>      we just need to know TID of the oldest cap flush. List is ideal for this
>      usage.
>      
>      Signed-off-by: Yan, Zheng <zyan@redhat.com>
> 
> While walking ci->i_cap_flush_list, __kick_flushing_caps drops and
> reacquires the i_ceph_lock on each iteration. It looks like
> __kick_flushing_caps could (e.g.) race with a reply from the MDS that
> removes the entry from the list. Is there something that prevents that
> that I'm not seeing?
>

I think it's protected by s_mutex. I checked the code only
ceph_kick_flushing_caps() is not protected by s_mutex. it should be 
easy to fix.

> Thanks,
> 

