Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E6044ADA0
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Nov 2021 13:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbhKIMg0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Nov 2021 07:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235446AbhKIMg0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 07:36:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30F5B60EE9;
        Tue,  9 Nov 2021 12:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636461220;
        bh=6pW1ANBmF+wcFSRgkTx2Gk8AKiT+TPGAG07YKQz7yQc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gT6upFJmNPBQCoWtpikAC5dVzDK1vPOQ0UqSc8xUbx0PY50vwhM4pDOX132a4oDjy
         lxkOjexI6QSQ6TLJofSr8WOBEPyJwbzc7aUcZKTF/K/XjIP8wEuVFpPUWWxfSk2FFN
         ytEF+yA1bHA4oKLc9X41xTyynOUyM4JF4iuWnLsth7vR2MJnp+kL3/F3bqzLoU1ZEF
         6OQznxvJAaO8xcQuy36xgwF2tlz55dggVxneNuC24LCJQQ+aSzlgzQI5U2iWSAge06
         LMsIbbUURk0519d1qd4rMmIh61LlQp5PNqi+fNkVoPJOomdd7OsDPZP4icsrW1k22a
         IgqwoMbPKNKTQ==
Message-ID: <ff4343cc402371813e40695cd556203df753bea0.camel@kernel.org>
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 09 Nov 2021 07:33:39 -0500
In-Reply-To: <f2ecc2760733b0cdde950b6a21bbbb8e9fb15f29.camel@kernel.org>
References: <20211108135012.79941-1-xiubli@redhat.com>
         <79e1517f6197185e3aca6b0afa5b810c5b5e8a82.camel@kernel.org>
         <ec7b0b1e-85de-6a4a-a772-5e00dd787d69@redhat.com>
         <f2ecc2760733b0cdde950b6a21bbbb8e9fb15f29.camel@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-11-08 at 20:57 -0500, Jeff Layton wrote:
> On Tue, 2021-11-09 at 08:21 +0800, Xiubo Li wrote:
> > On 11/9/21 2:36 AM, Jeff Layton wrote:
> > > On Mon, 2021-11-08 at 21:50 +0800, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > > 
> > > > Hi Jeff,
> > > > 
> > > > The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
> > > > The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.
> > > > 
> > > > Thanks.
> > > > 
> > > > Xiubo Li (2):
> > > >    ceph: fix possible crash and data corrupt bugs
> > > >    ceph: there is no need to round up the sizes when new size is 0
> > > > 
> > > >   fs/ceph/inode.c | 8 +++++---
> > > >   1 file changed, 5 insertions(+), 3 deletions(-)
> > > > 
> > > I'm running xfstests today with the current state of wip-fscrypt-size
> > > (including the two patches above) with test_dummy_encryption enabled.
> > > generic/030 failed. The expected output of this part of the test was:
> > > 
> > > wrote 5136912/5136912 bytes at offset 0
> > > XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > > ==== Pre-Remount ===
> > > 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> > > > XXXXXXXXXXXXXXXX|
> > > *
> > > 004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59
> > > > YYYYYYYYYYYYYYYY|
> > > *
> > > 004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00
> > > > YYYYYYYY........|
> > > 004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > > > ................|
> > > *
> > > 004e7000
> > > ==== Post-Remount ==
> > > 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> > > > XXXXXXXXXXXXXXXX|
> > > *
> > > 004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59
> > > > YYYYYYYYYYYYYYYY|
> > > *
> > > 004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00
> > > > YYYYYYYY........|
> > > 004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > > > ................|
> > > *
> > > 004e7000
> > > 
> > > ...but I got this instead:
> > > 
> > > wrote 5136912/5136912 bytes at offset 0
> > > XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > > ==== Pre-Remount ===
> > > 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> > > > XXXXXXXXXXXXXXXX|
> > > *
> > > 00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > > > ................|
> > > *
> > > 004e7000
> > > ==== Post-Remount ==
> > > 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> > > > XXXXXXXXXXXXXXXX|
> > > *
> > > 00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> > > > ................|
> > > *
> > > 004e7000
> > > 
> > > 
> > > ...I suspect this is related to the 075 failures, but I don't see it on
> > > every attempt, which makes me think "race condition". I'll keep hunting.
> > 
> > Yeah, seems the same issue.
> > 
> 
> I wonder if we're hitting the same problem that this patch was intended
> to fix:
> 
>     057ba5b24532 ceph: Fix race between hole punch and page fault
> 
> It seems like the problem is very similar. It may be worth testing a
> patch that takes the filemap_invalidate_lock across the on the wire
> truncate and the vmtruncate.


Nope. I tried a draft patch that make setattr hold this lock over the
MDS call and the vmtruncate and it didn't help.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>
