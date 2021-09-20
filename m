Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F2E4126DF
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Sep 2021 21:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345737AbhITT2V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Sep 2021 15:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245515AbhITT0T (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 15:26:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5843F610A0;
        Mon, 20 Sep 2021 19:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632165892;
        bh=9IHZ0lXSSqpdszFrG9Py9MvibFyJb6XKCQRZ2gDc7rQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q+V5RuQOvwiZa5EzsaSXTXTlowOFwiL4qTqOVIaekAKsDTdAfmyadjJLZZLC6K3HG
         plbvRomu89BLSEbLafE7eXHW8RmTdnqKi+bTZ2+zSlGMBKXqCT8Bp39sZ/DCwPFtRU
         /BgoGNwl84N5NyxC/FthRL3zaPVKu7NgP2kNmvnlTZ4Q986n72/aqS76Ex5KVxQxWI
         kmMv4GoX0KfrmGDHtz3YwLIdO7JFqY0cCjHCO+aShk6a24WlqjYo9P8HUYHUf4Lt0Q
         XuetwfOEpsSzKeYi5bh6yU0Uia7+ZbYspng6hUu72kA7KjNUhd7cn0/ZlctnM7NvHg
         vjTagqFA7hE9w==
Message-ID: <20c3630d2ac2e2e7c4a708fdeb7409077f36d8f0.camel@kernel.org>
Subject: Re: [PATCH RFC 2/2] ceph: truncate the file contents when needed
 when file scrypted
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Date:   Mon, 20 Sep 2021 15:24:49 -0400
In-Reply-To: <6d84f34d-28d4-1b82-3c70-1209bea37ddf@redhat.com>
References: <20210903081510.982827-1-xiubli@redhat.com>
         <20210903081510.982827-3-xiubli@redhat.com>
         <34538b56f366596fa96a8da8bf1a60f1c1257367.camel@kernel.org>
         <19fac1bf-804c-1577-7aa8-9dcfa52418f9@redhat.com>
         <e97616fc4f8f090f73a39f56de2ece7ed26fbd65.camel@kernel.org>
         <fabbaeae-d63e-a2e2-0717-47afea66f82f@redhat.com>
         <64c8d4daf2bfd9d20dd55ea1b29af7b7f690407d.camel@kernel.org>
         <cadc9f02-d52e-b1fc-1752-20dd6eb1d1c4@redhat.com>
         <90b25a04fb50b42559f1e153dd4b96df54a58c03.camel@kernel.org>
         <5f33583a-8060-1f0f-d200-abfbd1705ba1@redhat.com>
         <7eb2a71e54cb246a8ce1bea642bbdbd2581122f8.camel@kernel.org>
         <747cf4f4-0048-df9d-c38f-2ab284851320@redhat.com>
         <27b119711a065a2441337298fada3d941c30932a.camel@kernel.org>
         <3b2878f8-9655-b4a0-c6bd-3cf61eaffb13@redhat.com>
         <092f6a9ab8396b53f1f9e7af51e40563a2ea06d2.camel@kernel.org>
         <6d84f34d-28d4-1b82-3c70-1209bea37ddf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-09-20 at 22:32 +0800, Xiubo Li wrote:
> On 9/18/21 1:19 AM, Jeff Layton wrote:
> > On Thu, 2021-09-16 at 18:02 +0800, Xiubo Li wrote:
> > > 
> > > For this I am a little curious why couldn't we cache truncate operations
> > > when attr.ia_size >= isize ?
> > > 
> > It seems to me that if attr.ia_size == i_size, then there is nothing to
> > change. We can just optimize that case away, assuming the client has
> > caps that ensure the size is correct.
> 
>  From MDS side I didn't find any limitation why couldn't we optimize it.
> 
> 

Well...I think we do still need to change the mtime in that case. We
probably do still need to do a setattr or something that makes the MDS
set it to its current local time, even if the size doesn't change.

> > 
> > Based on the kclient code, for size changes after a write that extends a
> > file, it seems like Fw is sufficient to allow the client to buffer these
> > things.
> 
> Since the MDS will only allow us to increase the file size, just like 
> the mtime/ctime/atime, so even the write size has exceed current file 
> size, the Fw is sufficient.
> 

Good.

> 
> >   For a truncate (aka setattr) operation, we apparently need Fx.
> 
> In case one client is truncating the file, if the new size is larger 
> than or equal to current size, this should be okay and will behave just 
> like normal write case above.
> 
> If the new size is smaller, the MDS will handle this in a different way. 
> When the MDS received the truncate request, it will first xlock the 
> filelock, which will switch the filelock state and in all these possible 
> interim or stable states, the Fw caps will be revoked from all the 
> clients, but the clients still could cache/buffer the file contents, 
> that means no client is allowed to change the size during the truncate 
> operation is on the way. After the truncate succeeds the MDS Locker will 
> issue_truncate() to all the clients and the clients will truncate the 
> caches/buffers, etc.
> 
> And also the truncate operations will always be queued sequentially.
> 
> 
> > It sort of makes sense, but the more I look over the existing code, the
> > less sure I am about how this is intended to work. I think before we
> > make any changes for fscrypt, we need to make sure we understand what's
> > there now.
> 
> So if my understanding is correct, the Fx is not a must for the truncate 
> operation.
> 

Basically, when a truncate up or down comes in, we have to make a
determination of whether we can buffer that change, or whether we need
to do it synchronously.

The current kclient code bases that on whether it has Fx. I suspect
that ensures that no other client has Frw, which sounds like what we
probably want. We need to prevent anyone from doing writes that might
extend the file at that time _and_ need to ensure that stat/statx for
the file size blocks until it's complete. ceph_getattr will issue a
GETATTR to the MDS if it doesn't have Fs in that case, so that should
be fine.

I assume that the MDS will never give out Fx caps to one client and Fs
to another. What about Fw, though? Do Fx caps conflict with Frw the
same way as they do with Fs?
-- 
Jeff Layton <jlayton@kernel.org>

