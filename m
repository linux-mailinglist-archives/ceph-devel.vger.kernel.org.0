Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBE37CC0D8
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Oct 2023 12:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbjJQKnb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Oct 2023 06:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbjJQKna (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Oct 2023 06:43:30 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC47A2
        for <ceph-devel@vger.kernel.org>; Tue, 17 Oct 2023 03:43:29 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 3f1490d57ef6-d9beb863816so2125486276.1
        for <ceph-devel@vger.kernel.org>; Tue, 17 Oct 2023 03:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1697539408; x=1698144208; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OmZ/33TllYLHL47d/dVmhdUXpMsytcSlpt83kTPbFEw=;
        b=v1VTrk5a5bMTOZAKX2/e+XVcQcJmyGbghSCmPgyIzGBryi3CaKjqN09EYPuAacxJov
         p4wKEgL0UQafikbFUpuJOkA/w53hSzC7ZgBZ07Y+wYJDStMoMyXaRqZB9+y+nISGMtdy
         yT+NpBh5oPbMyKZ8XWbR32SUWLMYQN1rglWYApNNliuC/fg+owINkQyqZqv2lwpjhk2b
         lfjKfelGs7rBxb/EHzUHvDErgZiAPYhXwruP4Zl9BOyqgxYWsfQHeD47xgs0drMYjNsY
         xDt6RvYRGOXdbyU50V0/yHNVIX+I/XtRTsplsryIh+ZcuwK16EDTsKGqBp0AqP0zC4ut
         uGQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697539408; x=1698144208;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OmZ/33TllYLHL47d/dVmhdUXpMsytcSlpt83kTPbFEw=;
        b=QDJvl7yMOpe3qENADNnVRajXjSbBH3LHshxT9Oml6CWIBJE8mLsUWWNRUttC+m07io
         OdkOmBGtiMmx6+kHuBtf1vtLypqN4Jl7RiolA+qMQqh2RlphSsXjvW715YCWrL7wmlVU
         RJYM+B/xZPQ6GDomX0S5hrrO6uvxYbhMrmGxONrZIOeWKGcApOnfIa50RThSMop/JueK
         /LAFjRr1x5hCTm/H+Uol61ZmqC1r6PifoLB9/M2cC3EBf6W6LhwipA2+ePfretGioANT
         M6TWLHAlVPlhaZortUYk3aQ2ndnjb+pmDFo76Dp9l956O7vFgAh0vTELOKp7mMCWAFk4
         wn8A==
X-Gm-Message-State: AOJu0Yx2b64E3IvM26cv6TGAv6L9bvCBoVchM6B3yB9429tXibuuz88/
        RxIf6Zuyg6ysv3p9ggorCKZoroC+h+4Imz0L/Eui0A==
X-Google-Smtp-Source: AGHT+IEguG9VkvSZyN+YQKkbnzU4bPPMH68Gm77P3bS20bpQvkVCehXFFJFu9p/7GSuuBt2Sz4dkmWLIuiXDJ62NRdc=
X-Received: by 2002:a25:cd44:0:b0:d9b:6c9d:e6a with SMTP id
 d65-20020a25cd44000000b00d9b6c9d0e6amr1563929ybf.0.1697539408286; Tue, 17 Oct
 2023 03:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20231013155727.2217781-1-dhowells@redhat.com>
In-Reply-To: <20231013155727.2217781-1-dhowells@redhat.com>
From:   Daire Byrne <daire@dneg.com>
Date:   Tue, 17 Oct 2023 11:42:52 +0100
Message-ID: <CAPt2mGNpo0Uw0Ud18N4dV=ojoGK-xyj1P29tzWEhZw0i4FNVPg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/53] netfs, afs, cifs: Delegate high-level I/O to netfslib
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        Paulo Alcantara <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Christian Brauner <christian@brauner.io>,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 13 Oct 2023 at 16:58, David Howells <dhowells@redhat.com> wrote:
>
>  (2) Use of fscache is not yet tested.  I'm not sure whether to allow a
>      cache to be used with a write-through write.

Just adding a quick end user "thumbs up" for this potential feature.
We currently use fscache as the backend for "NFS re-export" servers to
extend our onprem storage to remote cloud compute (which works great).

But batch compute hosts (think VFX render farm) often chunk up stages
of work into multiple batch jobs such that they read data, write
results and then read the same data on different clients. Having the
ability to also cache the recent writes closer to the compute clients
(on the re-export server) would open up a lot of new workload
possibilities for us.

>  (5) Write-through caching will generate and dispatch write subrequests as
>      it gathers enough data to hit wsize and has whole pages that at least
>      span that size.  This needs to be a bit more flexible, allowing for a
>      filesystem such as CIFS to have a variable wsize.

If I understand correctly, this is above and beyond the normal write
back cache and is more in tune with the wsize (of NFS, CIFS etc) for
each file? Again, our workloads are over longer latencies than are
normal (NFS over 200ms!) so this sounds like a nice optimisation when
dealing with slow stuttering file writes over high latency.

I can definitely volunteer for some of the fscache + NFS testing.

Cheers,

Daire
