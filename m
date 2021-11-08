Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C013449BBB
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 19:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbhKHSj0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 13:39:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhKHSjZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 13:39:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27747613B3;
        Mon,  8 Nov 2021 18:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636396600;
        bh=sZqAHZsnrAUnkdUQJSQVhnoAGhtYQmnUo/r2vBaBM3U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bs7WfI/VUbOPGSQ5KYmr++ejPHrD73BoJuH4eIjA3jdYK658S04y/YPycQz7uaXO4
         pplEc2Nldl8D/mNcuOtghyUQwGLYUbvIeb6ueY+kCO53KxaWDHOb93qCq7Cd4S9dNf
         vr5utsXatOupaAmJKYmCsNcRlAn3zui3+9LRSqK8tbtxlLJof1SOHIVcrZeKfjFpE3
         H++MD9iqJvYkl8ZFxwZ8RZYpj4GXQoqnUA6OTqCW5ixHv6xYISXIr7TZf7WVCp419w
         Ani9yzcTDvkm/TVTRevXdtBMn1VC5BnAgjmRrQccGk16IAo3JEU+JD7avTxz21MQgK
         hin62oPKjv7gg==
Message-ID: <79e1517f6197185e3aca6b0afa5b810c5b5e8a82.camel@kernel.org>
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 08 Nov 2021 13:36:38 -0500
In-Reply-To: <20211108135012.79941-1-xiubli@redhat.com>
References: <20211108135012.79941-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-11-08 at 21:50 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Hi Jeff,
> 
> The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
> The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.
> 
> Thanks.
> 
> Xiubo Li (2):
>   ceph: fix possible crash and data corrupt bugs
>   ceph: there is no need to round up the sizes when new size is 0
> 
>  fs/ceph/inode.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

I'm running xfstests today with the current state of wip-fscrypt-size
(including the two patches above) with test_dummy_encryption enabled.
generic/030 failed. The expected output of this part of the test was:

wrote 5136912/5136912 bytes at offset 0
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
==== Pre-Remount ===
00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58 
|XXXXXXXXXXXXXXXX|
*
004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59 
|YYYYYYYYYYYYYYYY|
*
004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00 
|YYYYYYYY........|
004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
004e7000
==== Post-Remount ==
00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58 
|XXXXXXXXXXXXXXXX|
*
004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59 
|YYYYYYYYYYYYYYYY|
*
004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00 
|YYYYYYYY........|
004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
004e7000

...but I got this instead:

wrote 5136912/5136912 bytes at offset 0
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
==== Pre-Remount ===
00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58 
|XXXXXXXXXXXXXXXX|
*
00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
004e7000
==== Post-Remount ==
00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58 
|XXXXXXXXXXXXXXXX|
*
00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
004e7000


...I suspect this is related to the 075 failures, but I don't see it on
every attempt, which makes me think "race condition". I'll keep hunting.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>
