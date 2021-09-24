Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86639417B53
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Sep 2021 20:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344371AbhIXSyc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Sep 2021 14:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230025AbhIXSyb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 14:54:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CDEB61050;
        Fri, 24 Sep 2021 18:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509577;
        bh=v/jJlMRwcGgZg2bQW9xpusj7TP3iVoI0wo1J3RJVWqM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mYuIHuGxwM9VZKLKtpL7XScMYkrWNj9XFBU+lFxxjyy1wurPd2WO5GDwKlA2M+4IR
         +hJU7bR0h4fYqcgR8rO4cLjfP0UyOUiPTzadeC7quJrfRk6Zuphx4/qLvKHrd92mel
         xst2OydcUpR0kMQlfwjvqKei2b4ExdpdilhuNBtDhNaL3wIyKB0+oLDogi90Jb013p
         b0P0qqEoHn4FoJc3oJ+hC9cjQ+NlkebXJcF2xasoX3wI9XA59CYcRVQ4VnOSlrCSeE
         gMX5RWwXwzRg+X8aukhw0gLF9tqC/IkY0/F5r73xKSUAVBdll8Ucqx3kYK3PbMF8e8
         t7DMOJkpO0egA==
Message-ID: <066668c34c8022c18df4634bb2fb9ecfd1d6d93b.camel@kernel.org>
Subject: Re: [PATCH RFC 2/2] ceph: truncate the file contents when needed
 when file scrypted
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Date:   Fri, 24 Sep 2021 14:52:56 -0400
In-Reply-To: <5cf666a9-3b33-ad54-3878-a975505c872e@redhat.com>
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
         <20c3630d2ac2e2e7c4a708fdeb7409077f36d8f0.camel@kernel.org>
         <5cf666a9-3b33-ad54-3878-a975505c872e@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-09-22 at 10:23 +0800, Xiubo Li wrote:
> On 9/21/21 3:24 AM, Jeff Layton wrote:
> > On Mon, 2021-09-20 at 22:32 +0800, Xiubo Li wrote:
> > > On 9/18/21 1:19 AM, Jeff Layton wrote:
> > > > On Thu, 2021-09-16 at 18:02 +0800, Xiubo Li wrote:
> > > > > For this I am a little curious why couldn't we cache truncate operations
> > > > > when attr.ia_size >= isize ?
> > > > > 
> > > > It seems to me that if attr.ia_size == i_size, then there is nothing to
> > > > change. We can just optimize that case away, assuming the client has
> > > > caps that ensure the size is correct.
> > >   From MDS side I didn't find any limitation why couldn't we optimize it.
> > > 
> > > 
> > Well...I think we do still need to change the mtime in that case. We
> > probably do still need to do a setattr or something that makes the MDS
> > set it to its current local time, even if the size doesn't change.
> 
> Since there hasn't any change for the file data, will change the 'mtime' 
> make sense here ? If so, then why in case the current client has the Fr 
> caps and sizes are the same it won't.
> 
> In this case I found in the MDS side, it will also update the 'ctime' 
> always even it will change nothing.
> 

I think I'm wrong here, actually, but the POSIX spec is a bit vague on
the topic. Conceptually though since nothing changed, it doesn't seem
like we'd be mandated to change the mtime or change attribute.

https://pubs.opengroup.org/onlinepubs/9699919799/functions/truncate.html

> > > > Based on the kclient code, for size changes after a write that extends a
> > > > file, it seems like Fw is sufficient to allow the client to buffer these
> > > > things.
> > > Since the MDS will only allow us to increase the file size, just like
> > > the mtime/ctime/atime, so even the write size has exceed current file
> > > size, the Fw is sufficient.
> > > 
> > Good.
> > 
> > > >    For a truncate (aka setattr) operation, we apparently need Fx.
> > > In case one client is truncating the file, if the new size is larger
> > > than or equal to current size, this should be okay and will behave just
> > > like normal write case above.
> > > 
> > > If the new size is smaller, the MDS will handle this in a different way.
> > > When the MDS received the truncate request, it will first xlock the
> > > filelock, which will switch the filelock state and in all these possible
> > > interim or stable states, the Fw caps will be revoked from all the
> > > clients, but the clients still could cache/buffer the file contents,
> > > that means no client is allowed to change the size during the truncate
> > > operation is on the way. After the truncate succeeds the MDS Locker will
> > > issue_truncate() to all the clients and the clients will truncate the
> > > caches/buffers, etc.
> > > 
> > > And also the truncate operations will always be queued sequentially.
> > > 
> > > 
> > > > It sort of makes sense, but the more I look over the existing code, the
> > > > less sure I am about how this is intended to work. I think before we
> > > > make any changes for fscrypt, we need to make sure we understand what's
> > > > there now.
> > > So if my understanding is correct, the Fx is not a must for the truncate
> > > operation.
> > > 
> > Basically, when a truncate up or down comes in, we have to make a
> > determination of whether we can buffer that change, or whether we need
> > to do it synchronously.
> > 
> > The current kclient code bases that on whether it has Fx. I suspect
> > that ensures that no other client has Frw, which sounds like what we
> > probably want.
> 
> The Fx caps is only for the loner client and once the client has the Fx 
> caps it will always have the Fsrwcb at the same time. From the 
> mds/locker.cc I didn't find it'll allow that.
> 

So if I'm a "loner" client, then no one else has _any_ caps, right? If
so, then really Fx conflicts with all other FILE caps.

> If current client has the Fx caps, so when there has another client is 
> trying to truncate the same file at the same time, the MDS will have to 
> revoke the Fx caps first and during which the buffered truncate will be 
> flushed and be finished first too. So when Fx caps is issued and new 
> size equals to the current size, why couldn't we buffer it ?
> 
> 

I think we should be able to buffer it in that case.

> >   We need to prevent anyone from doing writes that might
> > extend the file at that time
> 
> Yeah, since the Fx is only for loner client, and all other clients will 
> have zero file caps. so it won't happen.
> 


What would be nice is to formally define what it means to be a "loner"
client? Does that mean that no other client has any outstanding caps?

A related question: Is loner status attached to the client or the cap
family? IOW, can I be a loner for FILE caps but not AUTH caps?

> 
> >   _and_ need to ensure that stat/statx for
> > the file size blocks until it's complete. ceph_getattr will issue a
> > GETATTR to the MDS if it doesn't have Fs in that case, so that should
> > be fine.
> > 
> > I assume that the MDS will never give out Fx caps to one client and Fs
> > to another.
> Yeah, It won't happen.
> 
> 
> >   What about Fw, though?
> 
> While for the Fw caps, it will allow it. If the filelock is in LOCK_MIX 
> state, the filelock maybe in this state if there at least one client 
> wants the Fw caps and some others want any of Fr and Fw caps.
> 

Sorry, I think you misunderstood my question.

We have to think about whether certain caps conflict with one another
when given to different clients. I meant do Fx and Fw conflict with one
another? If a client holds Fx and another requests Fw, then the MDS will
need to revoke Fx before it will hand Fw to another client. Correct?

I suspect that's the case as nothing else makes any sense. :)

> 
> >   Do Fx caps conflict with Frw the
> > same way as they do with Fs?
> 
> Yeah, it will be the same with Fs.
> 

Thanks for doing the archaeology on this. This is all really good info.
We need to get this into the capabilities.rst file in the ceph tree. I'd
really like to see a formal writeup of how FILE caps work.

Maybe we need a nice ASCII art matrix that indicates how various FILE
caps conflict with one another?

-- 
Jeff Layton <jlayton@kernel.org>

