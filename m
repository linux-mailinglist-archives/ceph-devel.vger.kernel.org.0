Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DED436777
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Oct 2021 18:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhJUQVP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Oct 2021 12:21:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230441AbhJUQVM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 12:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634833136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T6yUHXDCJ1C4bwIVBI0pS677wtC3A8dJIjgudbpVBfQ=;
        b=UjLEtjy3TB0ptcoQC8SzWxyPtWxnVenx+3mjMgl5v6FVVGeX1YksHNjGdeubfi6CroxDx0
        Fw7nz5pEazMl+FvRx0yZH9DyeGKqLqN+sUIvVYLfayVPqGAebQkr0XKvb9q+PJwxsw5+q5
        UzHyHWkEYf8yszwT01rurO7IJZUDCwQ=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-4dn6kn7KOkerQhqMiFnQlA-1; Thu, 21 Oct 2021 12:18:55 -0400
X-MC-Unique: 4dn6kn7KOkerQhqMiFnQlA-1
Received: by mail-il1-f200.google.com with SMTP id e10-20020a92194a000000b00258acd999afso614891ilm.16
        for <ceph-devel@vger.kernel.org>; Thu, 21 Oct 2021 09:18:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T6yUHXDCJ1C4bwIVBI0pS677wtC3A8dJIjgudbpVBfQ=;
        b=itiHj4ZFk0NZIME0woEH25cqwhqHlAvswuk6pr0nvhIXkfJMd2k0feuDqaClnQiOVA
         zEkpXN/iipJwuoj8JUr1VavHfkybspBeW6y+PfOs1ybZxRXbBGvG8vKG3oQBKthUnqRU
         ef9b6CZ9Q6tvOLpLdRdaZ/4hJqdy3JcY5WUFmaQAW5hcHxBLEaQBar5ePAytFDuU976m
         A0yTMfVHOsRWoA5qxsd/1Y0QGKz4NDSSmLBdQaVKGnqvHSjEsRIv6I6UUEKdx8jz6EiZ
         CKibDe+YUCVDa8s+SJ119xdf9i3pabwlnCbSX8IIRMu+ad9DaeZimktpO6t+SX77STuf
         8N/A==
X-Gm-Message-State: AOAM532YcNq1zyfYrDiDNcJWUQLwCudORCQ4ZxKAKT6r2G+aBx7KDSXg
        FeFJ4Mm6wTRknZAqP9l2URlIhesq/yAFGmubPaIlMthBQG8mkE5TXpQzoNG9mbqyJ8Jq8uhYf3z
        yd3doX4REOl6vvPz7WKnxkRB/8cQR8DkyXm/XTw==
X-Received: by 2002:a05:6e02:1b88:: with SMTP id h8mr4249367ili.200.1634833134398;
        Thu, 21 Oct 2021 09:18:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5y9j7z3dJn9Glj8ooQ1Y//DehvKlW+RX8Ejsk0RiCAUP4d4N+GvEQQX2Jmru5XQiMXq9WTCoSUsp4sYgnr5I=
X-Received: by 2002:a05:6e02:1b88:: with SMTP id h8mr4249352ili.200.1634833134229;
 Thu, 21 Oct 2021 09:18:54 -0700 (PDT)
MIME-Version: 1.0
References: <20211020143708.14728-1-lhenriques@suse.de> <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
 <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com> <99209198dd9d8634245f153a90e4091851635a16.camel@kernel.org>
In-Reply-To: <99209198dd9d8634245f153a90e4091851635a16.camel@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 21 Oct 2021 12:18:28 -0400
Message-ID: <CA+2bHPZTazVGtZygdbthQ-AWiC3AN_hsYouhVVs=PDo5iowgTw@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
To:     Jeff Layton <jlayton@kernel.org>
Cc:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 21, 2021 at 11:44 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2021-10-21 at 09:52 -0400, Patrick Donnelly wrote:
> > On Wed, Oct 20, 2021 at 12:27 PM Jeff Layton <jlayton@kernel.org> wrote=
:
> > >
> > > On Wed, 2021-10-20 at 15:37 +0100, Lu=C3=ADs Henriques wrote:
> > > > This counter will keep track of the number of remote object copies =
done on
> > > > copy_file_range syscalls.  This counter will be filesystem per-clie=
nt, and
> > > > can be accessed from the client debugfs directory.
> > > >
> > > > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > > > Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> > > > ---
> > > > This is an RFC to reply to Patrick's request in [0].  Note that I'm=
 not
> > > > 100% sure about the usefulness of this patch, or if this is the bes=
t way
> > > > to provide the functionality Patrick requested.  Anyway, this is ju=
st to
> > > > get some feedback, hence the RFC.
> > > >
> > > > Cheers,
> > > > --
> > > > Lu=C3=ADs
> > > >
> > > > [0] https://github.com/ceph/ceph/pull/42720
> > > >
> > >
> > > I think this would be better integrated into the stats infrastructure=
.
> > >
> > > Maybe you could add a new set of "copy" stats to struct
> > > ceph_client_metric that tracks the total copy operations done, their
> > > size and latency (similar to read and write ops)?
> >
> > I think it's a good idea to integrate this into "stats" but I think a
> > local debugfs file for some counters is still useful. The "stats"
> > module is immature at this time and I'd rather not build any qa tests
> > (yet) that rely on it.
> >
> > Can we generalize this patch-set to a file named "op_counters" or
> > similar and additionally add other OSD ops performed by the kclient?
> >
>
>
> Tracking this sort of thing is the main purpose of the stats code. I'm
> really not keen on adding a whole separate set of files for reporting
> this.

Maybe I'm confused. Is there some "file" which is already used for
this type of debugging information? Or do you mean the code for
sending stats to the MDS to support cephfs-top?

> What's the specific problem with relying on the data in debugfs
> "metrics" file?

Maybe no problem? I wasn't aware of a "metrics" file.

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

