Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F54A33849C
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Mar 2021 05:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhCLESo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Mar 2021 23:18:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232065AbhCLESR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 23:18:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615522697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SCFDSTSuGn+Op3rSE0Mx78eTYc3PlSidY2/sviSYnKs=;
        b=ZpbUbGhbWdDSPGY0d63Eq9/xgHnelA96JOZlG2QcPRDvJFWxoLJUWOULZYyeSubQd2WW5E
        SXkSyt4E3d2Vt1i2TSSqUGrREWrgf0usGQQRsw2+RLbjivoCi5mzIE68kH/OJslqOfq+iu
        W8BVVE5UXxaUJd16UNFvglxK4N85O0k=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-GuTAOO-dNiiA4oYhK_Ve4A-1; Thu, 11 Mar 2021 23:18:15 -0500
X-MC-Unique: GuTAOO-dNiiA4oYhK_Ve4A-1
Received: by mail-il1-f198.google.com with SMTP id o1so3742247ilg.15
        for <ceph-devel@vger.kernel.org>; Thu, 11 Mar 2021 20:18:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SCFDSTSuGn+Op3rSE0Mx78eTYc3PlSidY2/sviSYnKs=;
        b=OSCmZS7gLu0Sx6ZlmsIGPus9lVnyJv0RWhjJEZnU+2blZVjFMzjFo6iCLu/QwOzUOT
         6+2f/6jYJmqAb0NK0m3WLEPGfctEnpGC+A00aqwyxKT6ERHZXVuuTaFfqnCpmgfCusjn
         r0MyHEzmpPU4nlvE7l92iMtVXnhSgs8LoqDOlFJsXo67EI9d3NaYY7lVcONB9ZXwdfQl
         xXPfI6GZU/ntX+mCt72BmLquRlqnlEL1ucZCiO6jJmYiVQ3JYwuHY5Jv6yaFV6l9SCxh
         QoDqVQgYFjjaWbC7F5wjQzy7LDbhuxa81RTjLSGuogAsCQMZQd9G+GHcSRFuPjLVeRpd
         cRIg==
X-Gm-Message-State: AOAM533QN2w4totkdvn4MuR6LbxYSFtaADTgIQE2tI8uoTHIAsc+29SQ
        lQuRTkcNjcuXOtnap6fBfiQjhPwmEllfUGbDCN+fcpHpTzifQbRK4bvleJP0vbG3/iSAy6u2oSN
        o0y/ucmELBm3UaCqsm3KA9qHlFWJR2nUUtBC51Q==
X-Received: by 2002:a05:6e02:110f:: with SMTP id u15mr1306048ilk.293.1615522693543;
        Thu, 11 Mar 2021 20:18:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFeZ7jAGlel0CIHASNoIbRv4BBOhVahSnL0AOFK23m9aLEeIEEXKTbL3vfq1qe0pV4aDFXt7aneplIS7ON+xE=
X-Received: by 2002:a05:6e02:110f:: with SMTP id u15mr1306039ilk.293.1615522693271;
 Thu, 11 Mar 2021 20:18:13 -0800 (PST)
MIME-Version: 1.0
References: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
In-Reply-To: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 11 Mar 2021 20:17:47 -0800
Message-ID: <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
Subject: Re: fscrypt and file truncation on cephfs
To:     Jeff Layton <jlayton@redhat.com>
Cc:     dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 11, 2021 at 8:15 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> tl;dr version: in cephfs, the MDS handles truncating object data when
> inodes are truncated. This is problematic with fscrypt.
>
> Longer version:
>
> I've been working on a patchset to add fscrypt support to kcephfs, and
> have hit a problem with the way that truncation is handled. The main
> issue is that fscrypt uses block-based ciphers, so we must ensure that
> we read and write complete crypto blocks on the OSDs.
>
> I'm currently using 4k crypto blocks, but we may want to allow this to
> be tunable eventually (though it will need to be smaller than and align
> with the OSD object size). For simplicity's sake, I'm planning to
> disallow custom layouts on encrypted inodes. We could consider adding
> that later (but it doesn't sound likely to be worthwhile).
>
> Normally, when a file is truncated (usually via a SETATTR MDS call), the
> MDS handles truncating or deleting objects on the OSDs. This is done
> somewhat lazily in that the MDS replies to the client before this
> process is complete (AFAICT).

So I've done some more research on this and it's not that simplistic.
Broadly, a truncate causes the following to happen:

- Revoke all write caps (but not Fcb) from clients.

- Journal the truncate operation.

- Respond with unsafe reply.

- After setattr is journalled, regrant Fs with new file size,
truncate_seq, truncate_size

- issue trunc cap update with new file size, truncate_seq,
truncate_size (looks redundant with prior step)

- actually start truncating objects above file size; concurrently
grant all wanted Fwb... caps wanted by client

- reply safe

From what I can tell, the clients use the truncate_seq/truncate_size
to avoid writing to data what the MDS plans to truncate. I haven't
really dug into how that works. Maybe someone more familiar with that
code can chime in.

So the MDS seems to truncate/delete objects lazily in the background
but it does so safely and consistently.

> Once we add fscrypt support, the MDS handling truncation becomes a
> problem, in that we need to be able to deal with complete crypto blocks.
> Letting the MDS truncate away part of a block will leave us with a block
> that can't be decrypted.
>
> There are a number of possible approaches to fixing this, but ultimately
> the client will have to zero-pad, encrypt and write the blocks at the
> edges since the MDS doesn't have access to the keys.
>
> There are several possible approaches that I've identified:
>
> 1/ We could teach the MDS the crypto blocksize, and ensure that it
> doesn't truncate away partial blocks. The client could tell the MDS what
> blocksize it's using on the inode and the MDS could ensure that
> truncates align to the blocks. The client will still need to write
> partial blocks at the edges of holes or at the EOF, and it probably
> shouldn't do that until it gets the unstable reply from the MDS. We
> could handle this by adding a new truncate op or extending the existing
> one.
>
> 2/ We could cede the object truncate/delete to the client altogether.
> The MDS is aware when an inode is encrypted so it could just not do it
> for those inodes. We also already handle hole punching completely on the
> client (though the size doesn't change there). Truncate could be a
> special case of that. Probably, the client would issue the truncate and
> then be responsible for deleting/rewriting blocks after that reply comes
> in. We'd have to consider how to handle delinquent clients that don't
> clean up correctly.

We can't really do this I think. The MDS necessarily mediates between
clients when files are truncated.

> 3/ We could maintain a separate field in the inode for the real
> inode->i_size that crypto-enabled clients would use. The client would
> always communicate a size to the MDS that is rounded up to the end of
> the last crypto block, such that the "true" size of the inode on disk
> would always be represented in the rstats. Only crypto-enabled clients
> would care about the "realsize" field. In fact, this value could
> _itself_ be encrypted too, so that the i_size of the file is masked from
> clients that don't have keys.
>
> Ceph's truncation machinery is pretty complex in general, so I could
> have missed other approaches or something that makes these ideas
> impossible. I'm leaning toward #3 here since I think it has the most
> benefit and keeps the MDS out of the whole business.

"realsize" could be mediated by the same locks as the inode size, so
it should not be a complicated addition. Informing the MDS about a
blocksize may be worse in the long run as it complicates all the
truncate code paths, I think. From our past conversations, I think we
posed (1) to generalize the (3) option? I don't have a strong opinion
now on which is better in the long run (either for encryption or the
maintainability of CephFS).

If you're going to encrypt the realsize I wonder what other metadata
you might encrypt?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

