Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C7C338D4E
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Mar 2021 13:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhCLMja (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Mar 2021 07:39:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231380AbhCLMjB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 07:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615552740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nIlzBPbjZQbl6BHlAFv9UYoKgz9oeKS/HuNWJmbna4Q=;
        b=Ypd3hQG6MLlveMyHPzrtGAZ7lizqI9D5m4nLVwMguOu+RRA9RuxQ4Dt7rkKfmGFkYwkxs/
        zysfzrZ3X3cPzrldUDan8AVLAebXRk8LJ+2B1KvFY2wAKMgFgGGmAsDcerr1YyTFLaEwCc
        zi1cZnTkNxT1odYGcl4nW/OZY+inS10=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-8y9vubXoMsy0tit4lVoBaQ-1; Fri, 12 Mar 2021 07:38:59 -0500
X-MC-Unique: 8y9vubXoMsy0tit4lVoBaQ-1
Received: by mail-qt1-f198.google.com with SMTP id d11so17751441qth.3
        for <ceph-devel@vger.kernel.org>; Fri, 12 Mar 2021 04:38:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nIlzBPbjZQbl6BHlAFv9UYoKgz9oeKS/HuNWJmbna4Q=;
        b=CulVvOwHZDEri3OZinr1ZgLETnPCcU/YPZH/1UnLZ0wkrwUTJlAUSIGRj2M33qkosb
         FZR1kWZEudi0qxMMnbOKA9VRMnAKq+b1ZoWV/D19qdcEJv+p43wyx2s7qKUzyKP+F4kL
         +l8yobbt0tdVr3dhLeniW1/ImgIh1nmlA8AqpD5+QoluGCZD0S3ltMwfEuyY1luxzCvs
         DKworVE+Pr3UyJwcLzRkWaNL8+P7dl/IFLemm2UbDljjqVkv6iC0JDmqZJ6GpPWT/AGy
         BKrrtj1Dc34v95lVIALG8bFWCNUDe2u7IIsJw/U4OPGKdsGApGSoZT/PmkPFEAH3nE3g
         Rrdw==
X-Gm-Message-State: AOAM532Fyle6GkCnATdiHPT9pibCBzOQk5l8tZUfsqZtS3c1OeTTggqM
        8uuELtCIdjroxA4iBk9Kc5JnRXOUf89pcAc9VgT5nDSsruoW8FSgkdlbXv3b5bHmlS7LZLOrv1L
        oW5LsVK60gcYn4mcqrEYnYQ==
X-Received: by 2002:a05:620a:1483:: with SMTP id w3mr12089662qkj.339.1615552738328;
        Fri, 12 Mar 2021 04:38:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfpJ8QSxUH7nfrAQ4LWCBfX3ECpWDEVLI7LR+fl3aCIBafKjnAgOugnzCbQpEnZs/SqmEjmg==
X-Received: by 2002:a05:620a:1483:: with SMTP id w3mr12089645qkj.339.1615552738066;
        Fri, 12 Mar 2021 04:38:58 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id r7sm3647556qtm.88.2021.03.12.04.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 04:38:57 -0800 (PST)
Message-ID: <23931514d86828b237d83f105ba2c58ece9014c0.camel@redhat.com>
Subject: Re: fscrypt and file truncation on cephfs
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Date:   Fri, 12 Mar 2021 07:38:56 -0500
In-Reply-To: <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
References: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
         <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-03-11 at 20:17 -0800, Patrick Donnelly wrote:
> On Thu, Mar 11, 2021 at 8:15 AM Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > tl;dr version: in cephfs, the MDS handles truncating object data when
> > inodes are truncated. This is problematic with fscrypt.
> > 
> > Longer version:
> > 
> > I've been working on a patchset to add fscrypt support to kcephfs, and
> > have hit a problem with the way that truncation is handled. The main
> > issue is that fscrypt uses block-based ciphers, so we must ensure that
> > we read and write complete crypto blocks on the OSDs.
> > 
> > I'm currently using 4k crypto blocks, but we may want to allow this to
> > be tunable eventually (though it will need to be smaller than and align
> > with the OSD object size). For simplicity's sake, I'm planning to
> > disallow custom layouts on encrypted inodes. We could consider adding
> > that later (but it doesn't sound likely to be worthwhile).
> > 
> > Normally, when a file is truncated (usually via a SETATTR MDS call), the
> > MDS handles truncating or deleting objects on the OSDs. This is done
> > somewhat lazily in that the MDS replies to the client before this
> > process is complete (AFAICT).
> 
> So I've done some more research on this and it's not that simplistic.
> Broadly, a truncate causes the following to happen:
> 
> - Revoke all write caps (but not Fcb) from clients.
> 
> - Journal the truncate operation.
> 
> - Respond with unsafe reply.
> 
> - After setattr is journalled, regrant Fs with new file size,
> truncate_seq, truncate_size
> 
> - issue trunc cap update with new file size, truncate_seq,
> truncate_size (looks redundant with prior step)
> 
> - actually start truncating objects above file size; concurrently
> grant all wanted Fwb... caps wanted by client
> 
> - reply safe
> 
> From what I can tell, the clients use the truncate_seq/truncate_size
> to avoid writing to data what the MDS plans to truncate. I haven't
> really dug into how that works. Maybe someone more familiar with that
> code can chime in.
> 
> So the MDS seems to truncate/delete objects lazily in the background
> but it does so safely and consistently.
> 
> > Once we add fscrypt support, the MDS handling truncation becomes a
> > problem, in that we need to be able to deal with complete crypto blocks.
> > Letting the MDS truncate away part of a block will leave us with a block
> > that can't be decrypted.
> > 
> > There are a number of possible approaches to fixing this, but ultimately
> > the client will have to zero-pad, encrypt and write the blocks at the
> > edges since the MDS doesn't have access to the keys.
> > 
> > There are several possible approaches that I've identified:
> > 
> > 1/ We could teach the MDS the crypto blocksize, and ensure that it
> > doesn't truncate away partial blocks. The client could tell the MDS what
> > blocksize it's using on the inode and the MDS could ensure that
> > truncates align to the blocks. The client will still need to write
> > partial blocks at the edges of holes or at the EOF, and it probably
> > shouldn't do that until it gets the unstable reply from the MDS. We
> > could handle this by adding a new truncate op or extending the existing
> > one.
> > 
> > 2/ We could cede the object truncate/delete to the client altogether.
> > The MDS is aware when an inode is encrypted so it could just not do it
> > for those inodes. We also already handle hole punching completely on the
> > client (though the size doesn't change there). Truncate could be a
> > special case of that. Probably, the client would issue the truncate and
> > then be responsible for deleting/rewriting blocks after that reply comes
> > in. We'd have to consider how to handle delinquent clients that don't
> > clean up correctly.
> 
> We can't really do this I think. The MDS necessarily mediates between
> clients when files are truncated.
> 

Ok. I suppose we could do something to ensure that the MDS doesn't do
anything conflicting until the client is done truncating, but that's
probably more complex overall than the other options.

> > 3/ We could maintain a separate field in the inode for the real
> > inode->i_size that crypto-enabled clients would use. The client would
> > always communicate a size to the MDS that is rounded up to the end of
> > the last crypto block, such that the "true" size of the inode on disk
> > would always be represented in the rstats. Only crypto-enabled clients
> > would care about the "realsize" field. In fact, this value could
> > _itself_ be encrypted too, so that the i_size of the file is masked from
> > clients that don't have keys.
> > 
> > Ceph's truncation machinery is pretty complex in general, so I could
> > have missed other approaches or something that makes these ideas
> > impossible. I'm leaning toward #3 here since I think it has the most
> > benefit and keeps the MDS out of the whole business.
> 
> "realsize" could be mediated by the same locks as the inode size, so
> it should not be a complicated addition. Informing the MDS about a
> blocksize may be worse in the long run as it complicates all the
> truncate code paths, I think. From our past conversations, I think we
> posed (1) to generalize the (3) option? I don't have a strong opinion
> now on which is better in the long run (either for encryption or the
> maintainability of CephFS).
> 

1 and 3 are a bit different. For 1, there is only the single size field
to maintain, and the MDS just has to be aware of the crypto blocksize so
it can do the truncation along the boundaries.

With 3, we'd have 2 size fields to maintain (though the MDS would treat
the new one as opaque). The clients would just be responsible for
setting the "original" size field along block boundaries and properly
maintaining the realsize.

It's a subtle difference, but I think #3 makes for fewer changes on the
MDS, and less awareness there of crypto in general.

> If you're going to encrypt the realsize I wonder what other metadata
> you might encrypt?
> 

I may have spoken too soon here. The min crypto blocksize is 16 bytes,
so we'd need to maintain a field at least that size in the inode if we
wanted to encrypt that data.

The realsize field would be a good candidate for that, but the other
fields probably can't easily be treated as opaque (maybe st_rdev, but
the other stuff probably can't be).

Still, we could potentially put realsize into a field that's 16 bytes
long and just zero-pad it out for now. We could then add other fields
later if we had some that were useful (maybe st_rdev?).

I'll probably not do that initially, but we could consider it later.
-- 
Jeff Layton <jlayton@redhat.com>

