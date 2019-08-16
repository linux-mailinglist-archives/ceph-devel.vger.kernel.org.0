Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA67902F6
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Aug 2019 15:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfHPN1S (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 16 Aug 2019 09:27:18 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43877 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfHPN1S (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 16 Aug 2019 09:27:18 -0400
Received: by mail-yb1-f196.google.com with SMTP id o82so1942120ybg.10
        for <ceph-devel@vger.kernel.org>; Fri, 16 Aug 2019 06:27:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ERNAii9hB91PGwJIt3TDjMRY9cxkVuaDX73C6OB2tnE=;
        b=KB+fmgkoAPFP23PL1TS+ubOuDA9W3WGvcgcS1uYxSEqdah+sVTskc1PGh3qRwv5fR/
         qjtl08ynKuAOLO/rGze6DPie4V86MP1VM5Nd8PUdIBIVaUOFsTZXdnW2nS2j+krPDbS7
         2BW+DayXA1zz/2TYK9AtWnhG0VBsyBYhBeNhdw0rm/+1zxZcVYTnxEcvAkd1jRcjU/lS
         HmlHUqXwkH9TVguw/JbdCIGJOXzsYWfEB8zj8+MZrUbO+P50KaXvpb0fBoBHmWkI0JBi
         WP94/3k9AMfL9OrVFqKynMcXZfYQzymGHUWqxPbVoWYdACMkQJjGKdMDNOyYOPSz+8d5
         Zzig==
X-Gm-Message-State: APjAAAWF+BH7oILQ2Aqnf1z9AvaMB3uq4kdKzqbsfS0WftD3TsEi6zhj
        brXBqPdaZ8PjpRVgfeU6bd4Jww==
X-Google-Smtp-Source: APXvYqzoEBkyZW8cB3D/07TrCCiHhRjqRj/tJFxDtsaozYgfbuUAKC/1MGpn/fACUZmJqtYzPJ958Q==
X-Received: by 2002:a25:be4b:: with SMTP id d11mr7542869ybm.206.1565962037506;
        Fri, 16 Aug 2019 06:27:17 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id y193sm1639272ywy.62.2019.08.16.06.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 06:27:16 -0700 (PDT)
Message-ID: <a1a1bd7918ef51c09a07ae28bdad4f85e978c1ed.camel@redhat.com>
Subject: Re: deprecating inline_data support for CephFS
From:   Jeff Layton <jlayton@redhat.com>
To:     Jonas Jelten <jelten@in.tum.de>, ceph-users <ceph-users@ceph.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "dev@ceph.io" <dev@ceph.io>
Date:   Fri, 16 Aug 2019 09:27:09 -0400
In-Reply-To: <f1829e2b-f78a-1202-b15a-2b23c9a6183d@in.tum.de>
References: <e392e00ed22ba37c37208988cf5a095150f6c45b.camel@redhat.com>
         <f1829e2b-f78a-1202-b15a-2b23c9a6183d@in.tum.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-08-16 at 14:12 +0200, Jonas Jelten wrote:
> Hi!
> 
> I've missed your previous post, but we do have inline_data enabled on our cluster.
> We've not yet benchmarked, but the filesystem has a wide variety of file sizes, and it sounded like a good idea to speed
> up performance. We mount it with the kernel client only, and I've had the subjective impression that latency was better
> once we enabled the feature. Now that you say the kernel client has no write support for it, my impression is probably
> wrong.
>
> I think inline_data is a nice and easy way to improve performance when the CephFS metadata are on SSDs but the bulk data
> is on HDDs. So I'd vote against removal and would instead vouch for improvements of this feature :)
> 
> If storage on the MDS is a problem, files could be stored on a different (e.g. SSD) pool instead, and the file size
> limit and pool selection could be configured via xattrs. And there was some idea to store small objects not in the OSD
> block, but only in the OSD's DB (which is more complicated to use than separate SSD-pool and HDD-pool, but when block.db
> is on an SSD the speed would be better). Maybe this could all be combined to have better small-file performance in CephFS!
> 

The main problem is developer time and the maintenance burden this
feature represents. This is very much a non-trivial thing to implement.
Consider that the read() and write() codepaths in the kernel already
have 3 main branches each:

buffered I/O (when Fcb caps are held)
synchronous I/O (when Fcb caps are not held)
O_DIRECT I/O

We could probably consolidate the O_DIRECT and sync I/O code somewhat,
but buffered is handled entirely differently. Once we mix in inline_data
support, we have to add a completely new branch for each of those cases,
effectively doubling the complexity.

We'd also need to add similar handing for mmap'ed I/O and for things
like copy_file_range.

But, even before that...I have some real concerns about the existing
handling, even with a single client.

While I haven't attempted to roll a testcase for it, I think we can
probably hit races where multiple tasks handling write page faults can
compete to uninline the data, potentially clobbering the others' writes.
Again, this is non-trivial to fix.

In summary I don't see a real future for this feature unless someone
wants to step up to own it and commit to fixing up these problems.


> On 16/08/2019 13.15, Jeff Layton wrote:
> > A couple of weeks ago, I sent a request to the mailing list asking
> > whether anyone was using the inline_data support in cephfs:
> > 
> >     https://docs.ceph.com/docs/mimic/cephfs/experimental-features/#inline-data
> > 
> > I got exactly zero responses, so I'm going to formally propose that we
> > move to start deprecating this feature for Octopus.
> > 
> > Why deprecate this feature?
> > ===========================
> > While the userland clients have support for both reading and writing,
> > the kernel only has support for reading, and aggressively uninlines
> > everything as soon as it needs to do any writing. That uninlining has
> > some rather nasty potential race conditions too that could cause data
> > corruption.
> > 
> > We could work to fix this, and maybe add write support for the kernel,
> > but it adds a lot of complexity to the read and write codepaths in the
> > clients, which are already pretty complex. Given that there isn't a lot
> > of interest in this feature, I think we ought to just pull the plug on
> > it.
> > 
> > How should we do this?
> > ======================
> > We should start by disabling this feature in master for Octopus. 
> > 
> > In particular, we should stop allowing users to call "fs set inline_data
> > true" on filesystems where it's disabled, and maybe throw a loud warning
> > about the feature being deprecated if the mds is started on a filesystem
> > that has it enabled.
> > 
> > We could also consider creating a utility to crawl an existing
> > filesystem and uninline anything there, if there was need for it.
> > 
> > Then, in a few release cycles, once we're past the point where someone
> > can upgrade directly from Nautilus (release Q or R?) we'd rip out
> > support for this feature entirely.
> > 
> > Thoughts, comments, questions welcome.
> > 

-- 
Jeff Layton <jlayton@redhat.com>

