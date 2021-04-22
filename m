Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0D4368674
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Apr 2021 20:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbhDVSTv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Apr 2021 14:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236906AbhDVSTo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 14:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619115540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4Z57Lsd6Nsw3Wv5o2AFnctS05lbxHLWro2FqqHsB8wM=;
        b=PeDstgfgNSvXjvicDR6cX7ZH8eb53y03jgOMbrBwMkiSXzVaMij6MxSif955tM+moirjIr
        et+PvaWEAsQFPpe/rmvRql0nkG4RZ+Qj5QYvuHw17hX/wOowWl8+gLDgKSn+kIj7b5ZRQn
        fnIvdt1BliT1mmGZfjb/SLopACkV6/o=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-9_oMRA8eMSGSAymRTUXKCw-1; Thu, 22 Apr 2021 14:18:56 -0400
X-MC-Unique: 9_oMRA8eMSGSAymRTUXKCw-1
Received: by mail-qt1-f197.google.com with SMTP id o15-20020ac872cf0000b02901b358afcd96so15911387qtp.1
        for <ceph-devel@vger.kernel.org>; Thu, 22 Apr 2021 11:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=4Z57Lsd6Nsw3Wv5o2AFnctS05lbxHLWro2FqqHsB8wM=;
        b=A1pGcNE9tFRd8EKbgo9Ro8jfAX022lJWBaqDdwQXjlrC/Dj5X4mNWZiLFNexkAsJgJ
         gW7R9dG2a0huDPXQwwTWw36i3e1RODq1fHvW7IoPk9SM031Bv3m1uvNXjSetrokQgsfI
         nzXIkQC3X4dLHYqoT4sgG1eVD8iIHuwfkAyEzED3CV1SAmezFRhHiECh36ssV2qVucWo
         ENW6yKw/ktrXOoPT+n8bpTEeSrs12HIvO8L0I7FOhJh8R5q/XKObH1LR5ts2UpVPxGWG
         RNrtHNoull1D8afatuYQ1ubEhatXuFThJO/qHTedtou1MkCF/s+0+yQl9n7CsTt5aXyE
         YtoQ==
X-Gm-Message-State: AOAM5327xlZyrbmBM/0+PbI+5cE33G9gLsnlQXsL/DlMfD1/QW7q4b/S
        qfLhIUuAHYIGFobDs1DBQf7nWhOI/nY1L7Yv/gZTa/I8Gpv3JoxfZJ9skSWsxdaeLY4RX7/jvSW
        JwCL3AZ3vituAt8gn4HhYVw==
X-Received: by 2002:a37:6004:: with SMTP id u4mr16404qkb.369.1619115535234;
        Thu, 22 Apr 2021 11:18:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWpV2w2Lv173/8Z+5FKLumx8yW5Kg6VF96ZetzgB1/Aa3JwkXQNDyTt+svoQNX8Em5Efpx6Q==
X-Received: by 2002:a37:6004:: with SMTP id u4mr16380qkb.369.1619115535017;
        Thu, 22 Apr 2021 11:18:55 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id r5sm2653736qtp.75.2021.04.22.11.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 11:18:54 -0700 (PDT)
Message-ID: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
Subject: ceph-mds infrastructure for fscrypt
From:   Jeff Layton <jlayton@redhat.com>
To:     dev <dev@ceph.io>, ceph-devel@vger.kernel.org
Cc:     Luis Henriques <lhenriques@suse.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Douglas Fuller <dfuller@redhat.com>
Date:   Thu, 22 Apr 2021 14:18:53 -0400
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tl;dr: we need to change the MDS infrastructure for fscrypt (again), and
I want to do it in a way that would clean up some existing mess and more
easily allow for future changes. The design is a bit odd though...

Sorry for the long email here, but I needed communicate this design, and
the rationale for the changes I'm proposing. First, the rationale:

I've been (intermittently) working on the fscrypt implementation for
cephfs, and have posted a few different draft proposals for the first
part of it [1], which rely on a couple of changes in the MDS:

- the alternate_names feature [2]. This is needed to handle extra-long
  filenames without allowing unprintable characters in the filename.

- setting an "fscrypted" flag if the inode has an fscrypt context blob
  in encryption.ctx xattr [3].

With the filenames part more or less done, the next steps are to plumb
in content encryption. Because the MDS handles truncates, we have to
teach it to align those on fscrypt block boundaries. Rather than foist
those details onto the MDS, the current idea is to add an opaque blob to
the inode that would get updated along with size changes. The client
would be responsible for filling out that field with the actual i_size,
and would always round the existing size field up to the end of the last
crypto block. That keeps the real size opaque to the MDS and the
existing size handling logic should "just work". Regardless, that means
we need another inode field for the size.

Storing the context in an xattr is also proving to be problematic [4].
There are some situations where we can end up with an inode that is
flagged as encrypted but doesn't have the caps to trust its xattrs. We
could just treat "encryption.ctx" as special and not require Xs caps to
read whatever cached value we have, and that might fix that issue, but
I'm not fully convinced that's foolproof. We might end up with no cached
context on a directory that is actually encrypted in some cases and not
have a context.

At this point, I'm thinking it might be best to unify all of the 
per-inode info into a single field that the MDS would treat as opaque.
Note that the alternate_names feature would remain more or less
untouched since it's associated more with dentries than inodes.

The initial version of this field would look something like this:

struct ceph_fscrypt_context {
	u8				version;	// == 1
	struct fscrypt_context_v2	fscrypt_ctx;	// 40 bytes
	__le32				blocksize	// 4k for now
	__le64				size;		// "real"
i_size
};

The MDS would send this along with any size updates (InodeStat, and
MClientCaps replies). The client would need to send this in cap
flushes/updates, and we'd also need to extend the SETATTR op too, so the
client can update this field in truncates (at least).

I don't look forward to having to plumb this into all of the different
client ops that can create inodes though. What I'm thinking we might
want to do is expose this field as the "ceph.fscrypt" vxattr.

The client can stuff that into the xattr blob when creating a new inode,
and the MDS can scrape it out of that and move the data into the correct
field in the inode. A setxattr on this field would update the new field
too. It's an ugly interface, but shouldn't be too bad to handle and we
have some precedent for this sort of thing.

The rules for handling the new field in the client would be a bit weird
though. We'll need to allow it to reading the fscrypt_ctx part without
any caps (since that should be static once it's set), but the size
handling needs to be under the same caps as the traditional size field
(Is that Fsx? The rules for this are never quite clear to me.)

Would it be better to have two different fields here -- fscrypt_auth and
fscrypt_file? Or maybe, fscrypt_static/_dynamic? We don't necessarily
need to keep all of this info together, but it seemed neater that way.

Thoughts? Opinions? Is this a horrible idea? What would be better?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

[1]: latest draft was posted here:
https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#t
[2]: https://github.com/ceph/ceph/pull/37297
[3]:
https://github.com/ceph/ceph/commit/7fe1c57846a42443f0258fd877d7166f33fd596f
[4]:
https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa


