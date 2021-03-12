Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F6B3387D2
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Mar 2021 09:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhCLIo0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Mar 2021 03:44:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232251AbhCLIoO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 03:44:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615538653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pUJr662Pc8x2rWErKhjzgsnPQ6CPSWndIwUFmlQs+cc=;
        b=cCpVv1t06tfEULWdPAgKDKBqnN9SJG4Tg7oWk99F2EqlWASDGtTsx7SClkhqgIPd/KkLB6
        aO4L55zmnThOQPzTFWKpqCBtMy36Z/nLNIK+Ov/CYFKd1v+DK8+/r5SVT/yJPCtr+Klov4
        m9x0pi290WjTv69uiKOUFJ6sf1xjIvs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-p4U3JejDNJ-0CNFjmDkV0Q-1; Fri, 12 Mar 2021 03:44:12 -0500
X-MC-Unique: p4U3JejDNJ-0CNFjmDkV0Q-1
Received: by mail-qv1-f72.google.com with SMTP id bt20so8196143qvb.0
        for <ceph-devel@vger.kernel.org>; Fri, 12 Mar 2021 00:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUJr662Pc8x2rWErKhjzgsnPQ6CPSWndIwUFmlQs+cc=;
        b=jrLOc5E8OgxqvGoPiuI024NEs6X9VB1jZTCoOZG1S/X5QlpUwK2pcTOkfb+9CYqap3
         kjev2UABzkzlqfZ6kOdX1w4IJjEwICKsmOrL3W/F5REvekqjeYjU/dCm27NfcZWdYs9o
         u2GMtLBWs0xKoQtwMrolvJMSNaoPFBn1W36l/5GZHwkdbqcqtRzjbNbj/3gToYBV8YZG
         xf3PAf7K7Op1V5mPstss7E2Q1M8zY03JyFUBUdRCrpSf84XfkD921yjELASX+d0rG/bU
         7uHa6bJLO/j5VQwjCbegWvQ/FfEK9azkf7k+3qBeeUinSgMm7mrAs0Mo39teC1HZkJGm
         n09Q==
X-Gm-Message-State: AOAM531n9OYxSArkOh8CENv6maR2JzgHnU52OmHREiGbGAkptsVNHVNW
        QuME5QbmGvTvU5zaS9YuwzWT23XeTQjvrpuVdwUNVE19vjM6GUH/4pl+OZyu/k55Iq9qNeE+iSF
        GVYacriKo/kBsKXFpfggGPlsp28AiLZogYnwwIQ==
X-Received: by 2002:a0c:83a4:: with SMTP id k33mr11504248qva.1.1615538651010;
        Fri, 12 Mar 2021 00:44:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3WnfPRxQyqB9dxYTQk9xihSXCByT8Wd8nz7E6WY9EPfAtQhIRkv2K2rxHcGiQdWau3uuhy+07okFG9dOpSd4=
X-Received: by 2002:a0c:83a4:: with SMTP id k33mr11504221qva.1.1615538650576;
 Fri, 12 Mar 2021 00:44:10 -0800 (PST)
MIME-Version: 1.0
References: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com> <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
In-Reply-To: <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Fri, 12 Mar 2021 00:43:59 -0800
Message-ID: <CAJ4mKGaaSn67XRkBemJC0XAWBTyWN_VjgEJfT8EB1cLaokAYvQ@mail.gmail.com>
Subject: Re: fscrypt and file truncation on cephfs
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>, dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 11, 2021 at 8:18 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
>
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

Right; ti's lazy in that it's not done immediately in a blocking
manner, but it's absolutely safe. Truncate seq and size are also
fields you can send to the OSD on read or write operations, and the
client includes them on every op. It just has to do a (reasonably)
simple conversion from the total truncate size the MDS gives it to
what that means for the object being accessed (based on the striping
pattern and object number).

I'll try and think a bit more on how to handle the special extra size
for encryption.

...although in my current sleep-addled state, I'm actually not sure we
need to add any permanent storage to the MDS to handle this case! We
can probably just extend the front-end truncate op so that it can take
a separate "real-truncate-size" and the logical file size, can't we?
-Greg

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
> If you're going to encrypt the realsize I wonder what other metadata
> you might encrypt?
>
> --
> Patrick Donnelly, Ph.D.
> He / Him / His
> Principal Software Engineer
> Red Hat Sunnyvale, CA
> GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io
>

