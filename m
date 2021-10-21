Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A6743690A
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Oct 2021 19:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhJURdL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Oct 2021 13:33:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231441AbhJURdJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 13:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634837453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SJAMQ/lcGY4sk4CL6bHetg46Z5X4ql3TWvBmtMeLlSQ=;
        b=BR6nwZR+O0lPA4MqzPIxl6ZIy7zxE6QlrtbfGA+jmy50Z+sANXQaTPUckCOTm5d0x2jyS5
        bUR1D4rjYDJZfLY5hj8LZqpWXfec2kg9R6bltvXKGmRgYrAnCxQ9iWz1aFQVw22KD5TQxl
        2BCqeRSv4a8jhgJTpo56YZ36EAGBWuA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-8NC28hmMPDinbvTpKfLhgA-1; Thu, 21 Oct 2021 13:30:49 -0400
X-MC-Unique: 8NC28hmMPDinbvTpKfLhgA-1
Received: by mail-il1-f199.google.com with SMTP id a14-20020a927f0e000000b002597075cb35so763125ild.18
        for <ceph-devel@vger.kernel.org>; Thu, 21 Oct 2021 10:30:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SJAMQ/lcGY4sk4CL6bHetg46Z5X4ql3TWvBmtMeLlSQ=;
        b=r9eAmKN4Kvzd9Wud+9QB4JZLQpZ9LUhOEGZe3Oo+Y99d6p2ueUKKIl+CWWhqelNgTI
         DEuQ1WqOmKSXZywxwklLRwCPQZZPVJZvlich7CnHtPeq8atCzcHMBpm0CgbJg0ifhUvF
         NgrBibbFkigfSd8T2TM4ag1pvX4qZMkf8eyukGjeKrO7ihRVj6t2Lv338rT1vn3NUiNg
         Ft9mPkhhzkwzYxam/BEY93xJDHI5haoJu+eAwuOfz2qllHaziEX/X0VVSkSMFVbKx6C2
         nYJ/wSBq4RVuYkZP24EUxKWvQzsZmy1xs35lkkcY8BSvNcpJD9cu7Bz2ViVY4LJR8pw5
         Q7FA==
X-Gm-Message-State: AOAM5306l6Vawnn8JbBLPX0+a0EhqS6LrCZhAKu658fbI9klfdFYu1lT
        OOrNW6jgouMVNXDNIXs8RDGd22ycu4BB2aaYOmNdlQnakcu+eBzApdJsWmweiAJcNYPjjGuKN2C
        hPfZUFMCv+hnB5ffSrq16yHrOgCXFfVW/T3Vk9Q==
X-Received: by 2002:a6b:cd8b:: with SMTP id d133mr5217589iog.88.1634837448898;
        Thu, 21 Oct 2021 10:30:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTaNSVoj5TrNXAKSIjv0MBeStkH8x98yGWxgTxTnTpaBqc0heWLE9BHcG/lmQnTXgf5MPiIIW3RuDROTFR000=
X-Received: by 2002:a6b:cd8b:: with SMTP id d133mr5217575iog.88.1634837448627;
 Thu, 21 Oct 2021 10:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211020143708.14728-1-lhenriques@suse.de> <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
 <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com>
 <99209198dd9d8634245f153a90e4091851635a16.camel@kernel.org>
 <CA+2bHPZTazVGtZygdbthQ-AWiC3AN_hsYouhVVs=PDo5iowgTw@mail.gmail.com> <e5627f7d9eb9cf2b753136e1187d5d6ff7789389.camel@kernel.org>
In-Reply-To: <e5627f7d9eb9cf2b753136e1187d5d6ff7789389.camel@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 21 Oct 2021 13:30:22 -0400
Message-ID: <CA+2bHPYacg5yjO9otP5wUVxgwxw+d4hroVQod5VeFUTJNosQ9w@mail.gmail.com>
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

On Thu, Oct 21, 2021 at 12:35 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2021-10-21 at 12:18 -0400, Patrick Donnelly wrote:
> > On Thu, Oct 21, 2021 at 11:44 AM Jeff Layton <jlayton@kernel.org> wrote=
:
> > >
> > > On Thu, 2021-10-21 at 09:52 -0400, Patrick Donnelly wrote:
> > > > On Wed, Oct 20, 2021 at 12:27 PM Jeff Layton <jlayton@kernel.org> w=
rote:
> > > > >
> > > > > On Wed, 2021-10-20 at 15:37 +0100, Lu=C3=ADs Henriques wrote:
> > > > > > This counter will keep track of the number of remote object cop=
ies done on
> > > > > > copy_file_range syscalls.  This counter will be filesystem per-=
client, and
> > > > > > can be accessed from the client debugfs directory.
> > > > > >
> > > > > > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > > > > > Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> > > > > > ---
> > > > > > This is an RFC to reply to Patrick's request in [0].  Note that=
 I'm not
> > > > > > 100% sure about the usefulness of this patch, or if this is the=
 best way
> > > > > > to provide the functionality Patrick requested.  Anyway, this i=
s just to
> > > > > > get some feedback, hence the RFC.
> > > > > >
> > > > > > Cheers,
> > > > > > --
> > > > > > Lu=C3=ADs
> > > > > >
> > > > > > [0] https://github.com/ceph/ceph/pull/42720
> > > > > >
> > > > >
> > > > > I think this would be better integrated into the stats infrastruc=
ture.
> > > > >
> > > > > Maybe you could add a new set of "copy" stats to struct
> > > > > ceph_client_metric that tracks the total copy operations done, th=
eir
> > > > > size and latency (similar to read and write ops)?
> > > >
> > > > I think it's a good idea to integrate this into "stats" but I think=
 a
> > > > local debugfs file for some counters is still useful. The "stats"
> > > > module is immature at this time and I'd rather not build any qa tes=
ts
> > > > (yet) that rely on it.
> > > >
> > > > Can we generalize this patch-set to a file named "op_counters" or
> > > > similar and additionally add other OSD ops performed by the kclient=
?
> > > >
> > >
> > >
> > > Tracking this sort of thing is the main purpose of the stats code. I'=
m
> > > really not keen on adding a whole separate set of files for reporting
> > > this.
> >
> > Maybe I'm confused. Is there some "file" which is already used for
> > this type of debugging information? Or do you mean the code for
> > sending stats to the MDS to support cephfs-top?
> >
> > > What's the specific problem with relying on the data in debugfs
> > > "metrics" file?
> >
> > Maybe no problem? I wasn't aware of a "metrics" file.
> >
>
> Yes. For instance:
>
> # cat /sys/kernel/debug/ceph/*/metrics
> item                               total
> ------------------------------------------
> opened files  / total inodes       0 / 4
> pinned i_caps / total inodes       5 / 4
> opened inodes / total inodes       0 / 4
>
> item          total       avg_lat(us)     min_lat(us)     max_lat(us)    =
 stdev(us)
> -------------------------------------------------------------------------=
----------
> read          0           0               0               0              =
 0
> write         5           914013          824797          1092343        =
 103476
> metadata      79          12856           1572            114572         =
 13262
>
> item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  =
total_sz(bytes)
> -------------------------------------------------------------------------=
---------------
> read          0           0               0               0              =
 0
> write         5           4194304         4194304         4194304        =
 20971520
>
> item          total           miss            hit
> -------------------------------------------------
> d_lease       11              0               29
> caps          5               68              10702
>
>
> I'm proposing that Luis add new lines for "copy" to go along with the
> "read" and "write" ones. The "total" counter should give you a count of
> the number of operations.

Okay that makes more sense!

Side note: I am a bit horrified by how computer-unfriendly that
table-formatted data is.

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

