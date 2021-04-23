Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87C9369218
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Apr 2021 14:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242226AbhDWM2e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 23 Apr 2021 08:28:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230225AbhDWM2Z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 23 Apr 2021 08:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619180868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BUCknGaECMccNqkzjD/jT3wcgWhxDpUrsKhzWIREQMQ=;
        b=G9+eO8r6Xwrrr18o4WImeDBNmImtohBfhH+7HrdpJxpCRJNoAg4pDUQQ5c5XUaTeII7He7
        mtiCgQIexpK6wuHlPrO78FH2k7SAMLCG03EaBrMeYEKnxB9+Z4kiCUc72ZtpgkR4OWg8nw
        TfL6lfu3aPxMxmaCdahqbdtiRNntIgk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-Ch5GYo4rMqiijZkOuimH8Q-1; Fri, 23 Apr 2021 08:27:47 -0400
X-MC-Unique: Ch5GYo4rMqiijZkOuimH8Q-1
Received: by mail-qk1-f197.google.com with SMTP id g76-20020a379d4f0000b02902e40532d832so8064676qke.20
        for <ceph-devel@vger.kernel.org>; Fri, 23 Apr 2021 05:27:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BUCknGaECMccNqkzjD/jT3wcgWhxDpUrsKhzWIREQMQ=;
        b=GXN4jcoTLFHPwCs0kgZtq1G1FEgwqHCyS0SZ0JOM5fp66MrhUGclRY/XDUYjx3GCx+
         9kRfSNsaa5pJQast0SrnhyFkM49cQy1n0uRb2bSFuCBQSHONc1OJ3H9ypCb0RgkqZ/bO
         h5a8gah0I+evJBVtdH0hEXTRYnUt6S7LV9vcBWRCVuoDKv5jDPXMsnPrIIP5uPHeHi/f
         tKom14OutPV7rXfjtWPE9JQGvVCjEMGUMS9WdzL3bHywvUPU4WCSRxMUgFZdpf/xrPgv
         /ciJFv0EVmqfKnBgEt4fdTOjTBuXlw2OhYa5czbXiiyLHfqbWXITOzEqpDY8sdsCRJs8
         pEaw==
X-Gm-Message-State: AOAM533F18C4191XM75eOK7aFyhnwi3TRnOwFvPDk9tmSnAA/ZOk9Wxm
        qVKaDuy8H/DT0Z67FqXCmqznuhr0vMwF2Y38RcmEoyt7EzRq8SFIXcjCIxYtt12KmVzw6XY2bvX
        ENq/tMk3l+xvisnDAFwaq2g==
X-Received: by 2002:a0c:b38b:: with SMTP id t11mr4126601qve.25.1619180866684;
        Fri, 23 Apr 2021 05:27:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxb6dvqX428pGeq9+NsB7Tvdt+ecKaIwFd/PHbjNh4g4OxphiryWzVxpioNeiobm6v0e+PKKQ==
X-Received: by 2002:a0c:b38b:: with SMTP id t11mr4126544qve.25.1619180866079;
        Fri, 23 Apr 2021 05:27:46 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id g4sm4261523qtg.86.2021.04.23.05.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 05:27:45 -0700 (PDT)
Message-ID: <eec1ed73f778a17d4150da9bb001d1457c06ffae.camel@redhat.com>
Subject: Re: ceph-mds infrastructure for fscrypt
From:   Jeff Layton <jlayton@redhat.com>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     dev <dev@ceph.io>, ceph-devel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Douglas Fuller <dfuller@redhat.com>
Date:   Fri, 23 Apr 2021 08:27:44 -0400
In-Reply-To: <8735vh8bpt.fsf@suse.de>
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
         <8735vh8bpt.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-04-23 at 12:46 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@redhat.com> writes:
> 
> > tl;dr: we need to change the MDS infrastructure for fscrypt (again), and
> > I want to do it in a way that would clean up some existing mess and more
> > easily allow for future changes. The design is a bit odd though...
> 
> Thanks for summarizing this issue in an email.  It really helps to see the
> full picture.
> 
> > Sorry for the long email here, but I needed communicate this design, and
> > the rationale for the changes I'm proposing. First, the rationale:
> > 
> > I've been (intermittently) working on the fscrypt implementation for
> > cephfs, and have posted a few different draft proposals for the first
> > part of it [1], which rely on a couple of changes in the MDS:
> > 
> > - the alternate_names feature [2]. This is needed to handle extra-long
> >   filenames without allowing unprintable characters in the filename.
> > 
> > - setting an "fscrypted" flag if the inode has an fscrypt context blob
> >   in encryption.ctx xattr [3].
> > 
> > With the filenames part more or less done, the next steps are to plumb
> > in content encryption. Because the MDS handles truncates, we have to
> > teach it to align those on fscrypt block boundaries. Rather than foist
> > those details onto the MDS, the current idea is to add an opaque blob to
> > the inode that would get updated along with size changes. The client
> > would be responsible for filling out that field with the actual i_size,
> > and would always round the existing size field up to the end of the last
> > crypto block. That keeps the real size opaque to the MDS and the
> > existing size handling logic should "just work". Regardless, that means
> > we need another inode field for the size.
> > 
> > Storing the context in an xattr is also proving to be problematic [4].
> > There are some situations where we can end up with an inode that is
> > flagged as encrypted but doesn't have the caps to trust its xattrs. We
> > could just treat "encryption.ctx" as special and not require Xs caps to
> > read whatever cached value we have, and that might fix that issue, but
> > I'm not fully convinced that's foolproof. We might end up with no cached
> > context on a directory that is actually encrypted in some cases and not
> > have a context.
> > 
> > At this point, I'm thinking it might be best to unify all of the 
> > per-inode info into a single field that the MDS would treat as opaque.
> > Note that the alternate_names feature would remain more or less
> > untouched since it's associated more with dentries than inodes.
> > 
> > The initial version of this field would look something like this:
> > 
> > struct ceph_fscrypt_context {
> > 	u8				version;	// == 1
> > 	struct fscrypt_context_v2	fscrypt_ctx;	// 40 bytes
> > 	__le32				blocksize	// 4k for now
> > 	__le64				size;		// "real"
> > i_size
> > };
> > 
> > The MDS would send this along with any size updates (InodeStat, and
> > MClientCaps replies). The client would need to send this in cap
> > flushes/updates, and we'd also need to extend the SETATTR op too, so the
> > client can update this field in truncates (at least).
> > 
> > I don't look forward to having to plumb this into all of the different
> > client ops that can create inodes though. What I'm thinking we might
> > want to do is expose this field as the "ceph.fscrypt" vxattr.
> > 
> > The client can stuff that into the xattr blob when creating a new inode,
> > and the MDS can scrape it out of that and move the data into the correct
> > field in the inode. A setxattr on this field would update the new field
> > too. It's an ugly interface, but shouldn't be too bad to handle and we
> > have some precedent for this sort of thing.
> 
> I don't really have an objection for this, but I'm not sure I understand
> why we would want to have this as a vxattr if the it will really be stored
> in the inode.  Will this make things easier on the client side?  Or is
> that just a matter of having visibility into these fields?
> 

Mainly because I don't want to have to extend a bunch of MDS calls. We
need to ship the context along with every create, which means we'd need
to extend the MClientRequest calls for openc, mkdir, mknod, symlink,
etc. Since we already send an xattr blob with all of those, we can just
stuff this into there and avoid having to extend them all.

Being able to fetch the value with getxattr is sort of secondary, but
it's nice too.

> The rules for handling the new field in the client would be a bitweird
> > though. We'll need to allow it to reading the fscrypt_ctx part without
> > any caps (since that should be static once it's set), but the size
> 
> The PIN cap seems to fit here as the ctx can be considered an "immutable"
> field to some extent.  This means that, if there's a context, it's safe to
> assume it's valid.
> 
> If it's possible to request PIN caps to be revoked (is it?), a client
> could simply do that when a directory is initially encrypted.  After that,
> any client getting PIN caps for it will have the new fscrypt_ctx.
> 

The client doesn't get to request a revocation from another client. It
can request caps itself (or do a regular MDS request), and the MDS may
revoke them from another client if they conflict. We'd need this to be
under some sort of cap with "exclusive" semantics, I think.

> > handling needs to be under the same caps as the traditional size field
> > (Is that Fsx? The rules for this are never quite clear to me.)
> 
>  [ A different question which is maybe a bit OT in this context but that
>    pops up in my mind quite often is how to handle multiple writers to the
>    same file.  It should be OK to have 2 clients doing O_DIRECT as long as
>    they are writing to different encryption blocks but it's still tricky,
>    isn't it?  Can't we end-up with a corrupted file that is completely
>    unrecoverable?  Should O_DIRECT be forbid in encrypted inodes?  Not to
>    mention LAZYIO... ]
> 

If the client doesn't have Fb caps and wants to write a partial block,
then it'll have to do a read/modify/write cycle, and the write will have
to assert that the object version hasn't changed since read.

So basically:

- read the complete block and get the object version
- decrypt it
- modify and reencrypt it
- do a write but preface the OSD write with a version assert that the
data hasn't changed

If we hit the version assertion, just do the whole thing all over again.
Terribly inefficient, but it should be safe.

I'll also note that the rados libraries have a way to assert on an
extent not having changed, so we could potentially do this a bit more
efficiently if we have multiple writers writing different blocks in the
same object.

> > Would it be better to have two different fields here -- fscrypt_auth and
> > fscrypt_file? Or maybe, fscrypt_static/_dynamic? We don't necessarily
> > need to keep all of this info together, but it seemed neater that way.
> > 
> > Thoughts? Opinions? Is this a horrible idea? What would be better?
> 
> I've been looping through this since yesterday and I'm convinced the
> design will need to be something close to what you just described.  I
> can't poke holes in it, but the devil is always on the details.
> 

Indeed. Please do let me know if you see anything. Thanks for the
thoughts on the matter!

-- 
Jeff Layton <jlayton@redhat.com>

