Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855BD44A45F
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Nov 2021 02:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbhKIB7t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 20:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241710AbhKIB7s (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 20:59:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CEB361156;
        Tue,  9 Nov 2021 01:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636423023;
        bh=ml1wo7ZRbnUGcevmPBEHflleuSUFydQNsFI3t1RgCGg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tY8sy7AQ8gC2F0ImOqV917VA/pm01hN9BBgnw23CWbvLkU2GykQf+AX7+Vs+vtCci
         SoCZL4KyuWio/zRNMln1B7unSvC4F1jtdIwNWP8yLZ9MkZJ0H8sTU1HdxaDJCOJbuh
         HTJl3j49p/rf8b4+V8aND7TYbUuPZZV2LeYN8kDNBUuC1vHlsSWRYjFdaTLxE6V+Dy
         kLYjiSufWZ3+L5za8D2nrAFTBOGiJOalI+GM7u3smQgBlycWs1ddb+doWoioCVCV0m
         b7lVOSldZbOh/Qr8ucvUlZHs+J4kgFJLLzzVzu2SQrtHsYsoofbGg73oqXIRcvHrY1
         9UDjOfM0DydXw==
Message-ID: <f2ecc2760733b0cdde950b6a21bbbb8e9fb15f29.camel@kernel.org>
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 08 Nov 2021 20:57:01 -0500
In-Reply-To: <ec7b0b1e-85de-6a4a-a772-5e00dd787d69@redhat.com>
References: <20211108135012.79941-1-xiubli@redhat.com>
         <79e1517f6197185e3aca6b0afa5b810c5b5e8a82.camel@kernel.org>
         <ec7b0b1e-85de-6a4a-a772-5e00dd787d69@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-11-09 at 08:21 +0800, Xiubo Li wrote:
> On 11/9/21 2:36 AM, Jeff Layton wrote:
> > On Mon, 2021-11-08 at 21:50 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Hi Jeff,
> > > 
> > > The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
> > > The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.
> > > 
> > > Thanks.
> > > 
> > > Xiubo Li (2):
> > >    ceph: fix possible crash and data corrupt bugs
> > >    ceph: there is no need to round up the sizes when new size is 0
> > > 
> > >   fs/ceph/inode.c | 8 +++++---
> > >   1 file changed, 5 insertions(+), 3 deletions(-)
> > > 
> > I'm running xfstests today with the current state of wip-fscrypt-size
> > (including the two patches above) with test_dummy_encryption enabled.
> > generic/030 failed. The expected output of this part of the test was:
> > 
> > wrote 5136912/5136912 bytes at offset 0
> > XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > ==== Pre-Remount ===
> > 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> > > XXXXXXXXXXXXXXXX|
> > *
> > 004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59
> > > YYYYYYYYYYYYYYYY|
> > *
> > 004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00
> > > YYYYYYYY........|
> > 004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > > ................|
> > *
> > 004e7000
> > ==== Post-Remount ==
> > 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> > > XXXXXXXXXXXXXXXX|
> > *
> > 004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59
> > > YYYYYYYYYYYYYYYY|
> > *
> > 004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00
> > > YYYYYYYY........|
> > 004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > > ................|
> > *
> > 004e7000
> > 
> > ...but I got this instead:
> > 
> > wrote 5136912/5136912 bytes at offset 0
> > XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > ==== Pre-Remount ===
> > 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> > > XXXXXXXXXXXXXXXX|
> > *
> > 00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > > ................|
> > *
> > 004e7000
> > ==== Post-Remount ==
> > 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> > > XXXXXXXXXXXXXXXX|
> > *
> > 00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > > ................|
> > *
> > 004e7000
> > 
> > 
> > ...I suspect this is related to the 075 failures, but I don't see it on
> > every attempt, which makes me think "race condition". I'll keep hunting.
> 
> Yeah, seems the same issue.
> 

I wonder if we're hitting the same problem that this patch was intended
to fix:

    057ba5b24532 ceph: Fix race between hole punch and page fault

It seems like the problem is very similar. It may be worth testing a
patch that takes the filemap_invalidate_lock across the on the wire
truncate and the vmtruncate.
-- 
Jeff Layton <jlayton@kernel.org>
