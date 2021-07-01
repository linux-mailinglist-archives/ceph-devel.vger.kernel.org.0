Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C763B8CA0
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Jul 2021 05:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhGADaz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 23:30:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhGADay (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 23:30:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625110104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PuKgCM+h4SWS2pQQ5C4dYMgzE51APG2Nr5dRJMd4FkE=;
        b=aeoNSYZgIawlsfcwE1YEh9nbIWCQ5sXU7YwHGWNG6KA6X/Upp1Rprd4UM2kN53VCfCqtXk
        FWT7MqngoIIvb0IJW2L8bGylQH7FRlrj/UJMSTb6wTCUuA4LftLoZhhPEcTlX4hAKAq3AQ
        WYHibKWuCSrffIrnmeSMWkMhi/wUdbI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-fvgW25KMPDiLWHqNCQ6N3Q-1; Wed, 30 Jun 2021 23:28:22 -0400
X-MC-Unique: fvgW25KMPDiLWHqNCQ6N3Q-1
Received: by mail-io1-f69.google.com with SMTP id z11-20020a05660229cbb029043af67da217so3410124ioq.3
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 20:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PuKgCM+h4SWS2pQQ5C4dYMgzE51APG2Nr5dRJMd4FkE=;
        b=f5f/cbHPuh0DplVa22A0+1YnAnmXSgI7rmKIJ8bZUcCPRjKHIf/RM3L7SAIQFSUo0C
         WEwyxhyVfik42lDib00pjptUmqv9Ow3OHKp1+q1D7ymGAga1Mf2g6Q6iNh3bh3FTlxAt
         rq/5dtZ5gQ92PRMi2xw128L4b65lIFgRw2jjc30mOKaIywQPxh+tVQ/2RgAZED+9s+Tq
         Ll9ttb09Cr11My0hjuzd/FwlyKMgbISXJyjk1lh1gbvovTfWamYwOMzSMDg0wS4FrDn/
         /xcslZ7AXo+adIvMkE7Ypbl0a/vsGG7OAIyIbdU6zp99w88ZNRtITz5JtRO07Da7IXHG
         1pvg==
X-Gm-Message-State: AOAM532q68YSi9bBAneP8aSxMSGf8OXs7ha2Go7cdxTXyh972RjPPk4C
        3H/lrAJDPaOHn8emMEnaYYuzMm8LQghN3amanC54aua9YGCWicu1w6FbOdveXSHho7A2Rveo6iR
        Oh58mG1WPcueN+FNXnefyd7U7yQhcmc4J1hDQYw==
X-Received: by 2002:a92:cd41:: with SMTP id v1mr29338951ilq.180.1625110102090;
        Wed, 30 Jun 2021 20:28:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQaUjAuDJ8Z3JuVUZDEd4HB9JBg/HPU3doHEMMuvecNFlvM04GW+7L+pJ5Na2i5wxf/8zYNFTm7u+M2CsJlcI=
X-Received: by 2002:a92:cd41:: with SMTP id v1mr29338944ilq.180.1625110101945;
 Wed, 30 Jun 2021 20:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210629044241.30359-1-xiubli@redhat.com> <20210629044241.30359-5-xiubli@redhat.com>
 <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
 <4f2f6de6-eb1f-1527-de73-2378f262228b@redhat.com> <2e8aabad80e166d7c628fde9d820fc5f403e034f.camel@kernel.org>
 <379d5257-f182-c455-9675-b199aeb8ce1b@redhat.com>
In-Reply-To: <379d5257-f182-c455-9675-b199aeb8ce1b@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 30 Jun 2021 20:27:55 -0700
Message-ID: <CA+2bHPZNQU9wZr2W3FjW453KKFVi4q+LwVyicTPQ7kihhoQpQg@mail.gmail.com>
Subject: Re: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Xiubo,

On Wed, Jun 30, 2021 at 6:16 PM Xiubo Li <xiubli@redhat.com> wrote:
> >> Normally the mdlog submit thread will be triggered per MDS's tick,
> >> that's 5 seconds. But this is not always true mostly because any other
> >> client request could trigger the mdlog submit thread to run at any time.
> >> Since the fsync is not running all the time, so IMO the performance
> >> impact should be okay.
> >>
> >>
> > I'm not sure I'm convinced.
> >
> > Consider a situation where we have a large(ish) ceph cluster with
> > several MDSs. One client is writing to a file that is on mds.0 and there
> > is little other activity there. Several other clients are doing heavy
> > I/O on other inodes (of which mds.1 is auth).
> >
> > The first client then calls fsync, and now the other clients stall for a
> > bit while mds.1 unnecessarily flushes its mdlog. I think we need to take
> > care to only flush the mdlog for mds's that we care about here.
>
> Okay, except the above case I mentioned I didn't find any case that
> could prevent us doing this.
>
> Let me test more about it by just flushing the mdlog in auth MDS.

I think Jeff raises a good point. I looked at the history of the
flush_mdlog session command. It was used to implement syncfs which
necessarily requires all MDS to flush their journals (at least those
MDS communicating with the client).

During my testing of the original bug I found that running "stat ."
prior to fsync caused the hang to go away. This is because the stat
forced the MDS to flush its log in order to issue new caps to the
client. I think we need to understand that behavior better: the MDS is
revoking caps on the client to execute the rename RPC. It is probably
sufficient to change fsync to getattr appropriate (read/shared) caps
instead of flush the MDS journal.

Your time on adding flush_mdlog is not wasted; I think a good followup
patch is to add syncfs support the same way ceph-fuse does.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

