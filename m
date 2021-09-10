Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93C8406AFA
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Sep 2021 13:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhIJLrv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Sep 2021 07:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232613AbhIJLrv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 07:47:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E607760F38;
        Fri, 10 Sep 2021 11:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631274400;
        bh=OxWHeGvVvzfe/R5z4ruxcPkIya9n4W9s1c/2zU4NyXU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b+iND1EqYTB46DKwFk/wGd4AYDtbQLeLLRl+p/wQ1iudfk+ROwUKMFvyOymUImBck
         acx5RitaK7ltywGiMy4nJuK2LBEFPxnLHp1kT8fF48dBDdAml8aVClVmEKbl9XVkBn
         zDBeKsXEN1T0xqlVX6KTfBy1BmBrf8u4GvlCRpF9qeZhM9mKzki0M0diqZ7QPO+euJ
         ZJofUl+0wvaB2IvTf/5y+7Qwty7Xi4WuXld3PX9QoI0zM5LyQ5q7j/GdZey4p7pCEj
         xkOMvWVntE2ERkkJcxCZ4j60Rz8rKomM3EaHUrEnDzwYl/HlIR78HWhyXSZIBsk3lU
         7hl587W/yYWWw==
Message-ID: <90b25a04fb50b42559f1e153dd4b96df54a58c03.camel@kernel.org>
Subject: Re: [PATCH RFC 2/2] ceph: truncate the file contents when needed
 when file scrypted
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Fri, 10 Sep 2021 07:46:38 -0400
In-Reply-To: <cadc9f02-d52e-b1fc-1752-20dd6eb1d1c4@redhat.com>
References: <20210903081510.982827-1-xiubli@redhat.com>
         <20210903081510.982827-3-xiubli@redhat.com>
         <34538b56f366596fa96a8da8bf1a60f1c1257367.camel@kernel.org>
         <19fac1bf-804c-1577-7aa8-9dcfa52418f9@redhat.com>
         <e97616fc4f8f090f73a39f56de2ece7ed26fbd65.camel@kernel.org>
         <fabbaeae-d63e-a2e2-0717-47afea66f82f@redhat.com>
         <64c8d4daf2bfd9d20dd55ea1b29af7b7f690407d.camel@kernel.org>
         <cadc9f02-d52e-b1fc-1752-20dd6eb1d1c4@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-09-10 at 10:30 +0800, Xiubo Li wrote:
> On 9/9/21 8:48 PM, Jeff Layton wrote:
> > On Thu, 2021-09-09 at 11:38 +0800, Xiubo Li wrote:
> > > On 9/8/21 9:57 PM, Jeff Layton wrote:
> > > > On Wed, 2021-09-08 at 17:37 +0800, Xiubo Li wrote:
> > > > > On 9/8/21 12:26 AM, Jeff Layton wrote:
> > > > > > On Fri, 2021-09-03 at 16:15 +0800, xiubli@redhat.com wrote:
> > > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > > > 
> > > > > > > When truncating the file, it will leave the MDS to handle that,
> > > > > > > but the MDS won't update the file contents. So when the fscrypt
> > > > > > > is enabled, if the truncate size is not aligned to the block size,
> > > > > > > the kclient will round up the truancate size to the block size and
> > > > > > > leave the the last block untouched.
> > > > > > > 
> > > > > > > The opaque fscrypt_file field will be used to tricker whether the
> > > > > > > last block need to do the rmw to truncate the a specified block's
> > > > > > > contents, we can get which block needs to do the rmw by round down
> > > > > > > the fscrypt_file.
> > > > > > > 
> > > > > > > In kclient side, there is not need to do the rmw immediately after
> > > > > > > the file is truncated. We can defer doing that whenever the kclient
> > > > > > > will update that block in late future. And before that any kclient
> > > > > > > will check the fscrypt_file field when reading that block, if the
> > > > > > > fscrypt_file field is none zero that means the related block needs
> > > > > > > to be zeroed in range of [fscrypt_file, round_up(fscrypt_file + PAGE_SIZE))
> > > > > > > in pagecache or readed data buffer.
> > > > > > > 
> > > > > > s/PAGE_SIZE/CEPH_FSCRYPT_BLOCK_SIZE/
> > > > > > 
> > > > > > Yes, on x86_64 they are equal, but that's not the case on all arches.
> > > > > > Also, we are moving toward a pagecache that may hold larger pages on
> > > > > > x86_64 too.
> > > > > >     
> > > > > Okay.
> > > > > > > Once the that block contents are updated and writeback
> > > > > > > kclient will reset the fscrypt_file field in MDS side, then 0 means
> > > > > > > no need to care about the truncate stuff any more.
> > > > > > > 
> > > > > > I'm a little unclear on what the fscrypt_file actually represents here.
> > > > > > 
> > > > > > I had proposed that we just make the fscrypt_file field hold the
> > > > > > "actual" i_size and we'd make the old size field always be a rounded-
> > > > > > up version of the size. The MDS would treat that as an opaque value
> > > > > > under Fw caps, and the client could use that field to determine i_size.
> > > > > > That has a side benefit too -- if the client doesn't support fscrypt,
> > > > > > it'll see the rounded-up sizes which are close enough and don't violate
> > > > > > any POSIX rules.
> > > > > > 
> > > > > > In your version, fscrypt_file also holds the actual size of the inode,
> > > > > > but sometimes you're zeroing it out, and I don't understand why:
> > > > > I think I forgot to fix this after I adapt to multiple ftruncates case,
> > > > > this patch is not correctly handling the "actual" file size.
> > > > > 
> > > > > I just want the fscrypt_file field always to hold the offset from which
> > > > > the contents needed to be zeroed, and the range should be [fscrypt_file,
> > > > > round_up(fscrypt_file +CEPH_FSCRYPT_BLOCK_SIZE)).
> > > > > 
> > > > > In single ftruncate case the fscrypt_file should equal to the "actual"
> > > > > file size. Then the "req->r_args.setattr.size = attr->ia_size" and
> > > > > "req->r_args.setattr.old_size = isize", no need to round up in
> > > > > __ceph_setattr() in kclient side, and leave the MDS to do that, but we
> > > > > need to pass the CEPH_FSCRYPT_BLOCK_SIZE at the same time.
> > > > > 
> > > > I'm really not a fan of pushing this logic into the MDS. Why does it
> > > > need to know anything about the CEPH_FSCRYPT_BLOCK_SIZE at all?
> > >   From your current patch set, you are rounding up the
> > > "req->r_args.setattr.size" and "req->r_args.setattr.old_size" to the
> > > BLOCK end in __ceph_setattr().
> > > 
> > > Without considering keep the file scryption logic in kclient only, I
> > > need the "req->r_args.setattr.size" to keep the file's real size.
> > > 
> > > Since the MDS will do the truncate stuff. And if we won't round the
> > > "req->r_args.setattr.size" up to the BLOCK end any more, then the MDS
> > > needs to know whether and how to round up the file size to the block end
> > > when truncating the file. Because the fscrypt_file won't record the
> > > file's real size any more, it maybe zero, more detail please see the
> > > example below.
> > > 
> > > Yeah, but as you mentioned bellow if we will keep the file scryption
> > > logic in kclient only, I need one extra field to do the defer rmw:
> > > 
> > > struct fscrypt_file {
> > > 
> > >       u64 file_real_size;         // always keep the file's real size and
> > > the "req->r_args.setattr.size = round_up(file_real_size, BLOCK_SIZE)" as
> > > you do in your current patch set.
> > > 
> > >       u64 file_truncate_offset;  // this will always record in which
> > > BLOCK we need to do the rmw, this maybe 0 or located in the file's LAST
> > > block and maybe not, more detail please the example below.
> > > 
> > > }
> > > 
> > > The "file_truncate_offset" member will be what I need to do the defer rmw.
> > > 
> > > 
> > > > > But in multiple ftruncates case if the second ftruncate has a larger
> > > > > size, the fscrypt_file won't be changed and the ceph backend will help
> > > > > zero the extended part, but we still need to zero the contents in the
> > > > > first ftruncate. If the second ftruncate has a smaller size, the
> > > > > fscrypt_file need to be updated and always keeps the smaller size.
> > > > > 
> > > > I don't get it. Maybe you can walk me through a concrete example of how
> > > > racing ftruncates are a problem?
> > > Sorry for confusing.
> > > 
> > > For example:
> > > 
> > > 1), if there has a file named "bar", and currently the size is 100K
> > > bytes, the CEPH_FSCRYPT_BLOCK_SIZE size equals to 4K.
> > > 
> > > 2), first ftruncate("bar", 7K) comes, then both the file real size and
> > > "file_truncate_offset" will be set to 7K, then in MDS it will truncate
> > > the file from 8K, and the last block's [7K, 8K) contents need to be
> > > zeroed anyway later.
> > > 
> > > 3), immediately a second ftruncate("bar", 16K) comes, from the ftruncate
> > > man page it says the new extended [7K, 16K) should be zeroed when
> > > truncating the file. That means the OSD should help zero the [8K, 16K),
> > > but won't touch the block [4K, 8K), in which the [7K, 8K) contents still
> > > needs to be zeroed. So in this case the "file_truncate_offset" won't be
> > > changed and still be 7K. Then the "file_truncate_offset" won't be
> > > located in the last block of the file any more.
> > > 
> > Woah, why didn't the file_truncate_offset get changed when you truncated
> > up to 16k?
> > 
> > When you issue the truncate SETATTR to the MDS, you're changing the size
> > field in the inode. The fscrypt_file field _must_ be updated at the same
> > time. I think that means that we need to extend SETATTR to also update
> > fscrypt_file.
> > 
> > > 4), if the second ftruncate in step 3) the new size is 3K, then the MDS
> > > will truncate the file from 4K and [7K, 8K) contents will be discard
> > > anyway, so we need to update the "file_truncate_offset" to 3K, that
> > > means a new BLOCK [0K, 4K) needs to do the rmw, by zeroing the [3K, 4K).
> > > 
> > > 5), if the new truncate in step 3) the new size is 4K, since the 4K < 7K
> > > and 4K is aligned to the BLOCK size, so no need to rmw any block any
> > > more, then we can just clear the "file_truncate_offset" field.
> > > 
> > > 
> > > For defer RMW logic please see the following example:
> > > 
> > > 
> > Ok, thanks. I think I understand now how racing truncates are a problem.
> > Really, it comes down to the fact that we don't have a good way to
> > mediate the last-block RMW operation when competing clients are issuing
> > truncates.
> > 
> > I'm not sure adding this file_truncate_offset field really does all that
> > much good though. You don't really have a way to ensure that a
> > truncating client will see the changes to that field before it issues
> > its RMW op.
> > 
> > > > Suppose we have a file and client1 truncates it down from a large size
> > > > to 7k. client1 then sends the MDS a SETATTR to truncate it at 8k, and
> > > > does a RMW on the last (4k) block. client2 comes along at the same time
> > > > and truncates it up to 13k. client2 issues a SETATTR to extend the file
> > > > to 16k and does a RMW on the last block too (which would presumably
> > > > already be all zeroes anyway).
> > > I think you meant in the none defer RMW case, this is not what my defer
> > > RMW approach will do.
> > > 
> > > After the client1 truncated the file, it won't do the RMW if it won't
> > > write any data to that file, and then we assume the client1 is unmounted
> > > immediately.
> > > 
> > > And when the client1 is truncating the file, it will update the
> > > "file_truncate_offset" to 7K, which means the [7K, 8K) in the LAST block
> > > needs to be zeroed.
> > > 
> > > Then the client2 reads that the file size is 7K and the
> > > "file_truncate_offset" is 7K too, and the client2 wants to truncate the
> > > file up to 13K. Since the OSD should help us zero the extended part [8K,
> > > 13K] when truncating, but won't touch the block [4K, 8K), for which it
> > > still needs to do the RMW. Then the client2 is unmounted too before
> > > writing any data to the file. After this the "file_truncate_offset"
> > > won't be located in the file's LAST block any more.
> > > 
> > > After that if the client3 will update the whole file's contents, it will
> > > read all the file 13K bytes contents to local page buffers, since the
> > > "file_truncate_offset" is 7K and then in the page buffer the range [7K,
> > > 8K) will be zeroed just after the contents are dencrypted inplace. Then
> > > if the client3 successfully flushes that dirty data back and then the
> > > deferred RMW for block [4K, 8K) should be done at the same time, and the
> > > "file_truncate_offset" should be cleared too.
> > > 
> > > While if the client3 won't update the block [4K, 8K), the
> > > "file_truncate_offset" will be kept all the time until the above RMW is
> > > done in future.
> > > 
> > > 
> > Ok, I think I finally understand what you're saying.
> > 
> > You want to rely on the next client to do a write to handle the zeroing
> > at the end. You basically just want to keep track of whether and where
> > it should zero up to the end of the next crypto block, and defer that
> > until a client is writing.
> 
> Yeah, the writing could also be in the same client just after the file 
> is truncated.
> 
> 
> > 
> > I'll have to think about whether that's still racy. Part of the problem
> > is that once the client doesn't have caps, it doesn't have a way to
> > ensure that fscrypt_file (whatever it holds) doesn't change while it's
> > doing that zeroing.
> 
> As my understanding, if clientA want to read a file, it will open it 
> with RD mode, then it will get the fscrypt_file meta and "Fr" caps, then 
> it can safely read the file contents and do the zeroing for that block. 

Ok, so in this case, the client is just zeroing out the appropriate
region in the resulting read data, and not on the OSD. That should be
ok.

> Then the opened file shouldn't worry whether the fscrypt_file will be 
> changed by others during it still holding the Fr caps, because if the 
> clientB wants to update the fscrypt_file it must acquire the Fw caps 
> first, before that the Fr caps must be revoked from clientA and at the 
> same time the read pagecache in clientA will be invalidated.
> 

Are you certain that Fw caps is enough to ensure that no other client
holds Fr caps? IIRC, Frw don't have the same exclusionary relationship
that (e.g.) Asx has. To exclude Fr, you may need Fb.

(Side note: these rules really need to be codified into a document
somewhere. I started that with the capabilities doc in the ceph tree,
but it's light on details of the FILE caps)

> And if after clientB have been issued the Fw caps and have modified that 
> block and still not flushed back, a new clientC comes and wants to read 
> the file, so the Fw caps must be revoked from clientB and the dirty data 
> will be flushed, and then when releasing the Fw caps to the MDS, it will 
> update the new fscrypt_file meta together.
> 
> I haven't see which case will be racy yet. Or did I miss some cases or 
> something important ?
> 
> 

We also need to consider how legacy, non-fscrypt-capable clients will
interact with files that have this field set. If one comes in and writes
to or truncates one of these files, it's liable to leave a real mess.
The simplest solution may be to just bar them from doing anything with
fscrypted files aside from deleting them -- maybe we'd allow them to
acquire Fr caps but not Fw?

> > 
> > Really, it comes down to the fact that truncates are supposed to be an
> > atomic operation, but we need to perform actions in two different
> > places.
> > 
> > Hmmm...it's worse than that even -- if the truncate changes it so that
> > the last block is in an entirely different object, then there are 3
> > places that will need to coordinate access.
> > 
> > Tricky.
> 

-- 
Jeff Layton <jlayton@kernel.org>

