Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F794481AF
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 15:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbhKHO3M (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 09:29:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239423AbhKHO3L (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 09:29:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6934E610A3;
        Mon,  8 Nov 2021 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636381586;
        bh=91VlVoT8Ncmz50dUWGwWw26x6ij9VDc+7k0H7DHtkmk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mykayUIJLvusCXEoQiEWgBHfHSJz2e4+KXBwKq9kY6+Wx9WWQy93qGOFxB6HBGciQ
         cM2E9sLXAgup0Am/IUb3UQYcCgA087Olc0Fe/6wIeagl05rflGHW8bHP2Ncei0j02L
         j+BNT7b17sVNsxIiJ75jlFlePAv/uzNXs92O1DelgCA7ULYCYrMlo05hzZr9YyAXmc
         ATjEw2oAg8gtmb8f7588A76E86B8QvNgZEbGBi7kpYz9CaJhuIk4Aolxe//Lpll9hP
         dZpwLdAq8J1OeT/FoCMfBMoM76XDrBBV/es3JWOhtgmJhPPqUvu+sKeC0E3NoOm6yb
         xoMgNIhdEn4UQ==
Message-ID: <b4ce8eecc10c0796f233d42c5a92d2dead4a5f85.camel@kernel.org>
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 08 Nov 2021 09:26:25 -0500
In-Reply-To: <25c8bbac-99c1-66a9-cb79-96eb0213c702@redhat.com>
References: <20211108135012.79941-1-xiubli@redhat.com>
         <25c8bbac-99c1-66a9-cb79-96eb0213c702@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-11-08 at 22:10 +0800, Xiubo Li wrote:
> Hi Jeff,
> 
> After this fixing, there still has one bug and I am still looking at it:
> 
> [root@lxbceph1 xfstests]# ./check generic/075
> FSTYP         -- ceph
> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0-rc6+
> 
> generic/075     [failed, exit status 1] - output mismatch (see 
> /mnt/kcephfs/xfstests/results//generic/075.out.bad)
>      --- tests/generic/075.out    2021-11-08 20:54:07.456980801 +0800
>      +++ /mnt/kcephfs/xfstests/results//generic/075.out.bad 2021-11-08 
> 21:20:49.741906997 +0800
>      @@ -12,7 +12,4 @@
>       -----------------------------------------------
>       fsx.2 : -d -N numops -l filelen -S 0
>       -----------------------------------------------
>      -
>      ------------------------------------------------
>      -fsx.3 : -d -N numops -l filelen -S 0 -x
>      ------------------------------------------------
>      ...
>      (Run 'diff -u tests/generic/075.out 
> /mnt/kcephfs/xfstests/results//generic/075.out.bad'  to see the entire diff)
> Ran: generic/075
> Failures: generic/075
> Failed 1 of 1 tests
> 
> 
> I checked the result outputs, it seems when truncating the size to a 
> smaller sizeA and then to a bigger sizeB again, in theory those contents 
> between sizeA and sizeB should be zeroed, but it didn't.
> 
> The last block updating is correct.
> 
> Any idea ?
> 


Yep, that's the one I saw (intermittently) too. I also saw some failures
around generic/029 and generic/030 that may be related. I haven't dug
down as far into the problem as you have though.

The nice thing about fsx is that it gives you a lot of info about what
it does. There is also a way to replay a series of ops too, so you may
want to try to see if you can make a reliable reproducer for this
problem.

Are these truncates running concurrently in different tasks? If so, then
we may need some mechanism to ensure that they are serialized vs. one
another.

> 
> On 11/8/21 9:50 PM, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > Hi Jeff,
> > 
> > The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
> > The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.
> > 
> > Thanks.
> > 
> > Xiubo Li (2):
> >    ceph: fix possible crash and data corrupt bugs
> >    ceph: there is no need to round up the sizes when new size is 0
> > 
> >   fs/ceph/inode.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> 

-- 
Jeff Layton <jlayton@kernel.org>
