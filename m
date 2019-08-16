Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DEB90091
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Aug 2019 13:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfHPLPV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 16 Aug 2019 07:15:21 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44394 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfHPLPV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 16 Aug 2019 07:15:21 -0400
Received: by mail-yw1-f68.google.com with SMTP id l79so1657772ywe.11
        for <ceph-devel@vger.kernel.org>; Fri, 16 Aug 2019 04:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=mh6AzGY70LwhJ4eTO/EZzHypKHxPoSvzNb5Iich9FKc=;
        b=H55OOFTQmSaF+P/z8fyxTEFJTPwjhUKLUMRtSsnbzT/qkoOM1l7wnjDSeln40lvs9h
         E1/fR52U9b7BrB4Q4N47PuunjJKkbbEx8AzyYbck1utG6vo3TZpeJl6yOqLGJphfFCQd
         zcCsqRUdZ0t6WQzJy1PNJxTGvfmFymE6FWqGWXnoi94QoGy4gAu+CJ4zgzVc2gi8U9zh
         chPDm0zGdcferWlEpIhIzm645vl3ka8Meba0PaXfIuN8xJ2a4VNG3nH1XZEq17j5Uyl9
         58JMJoUy01sUj2V6RVY6g69kOj964zKz23/09hbF75hJ0GDBc0NcDlcUF9FI6JRhCdag
         +iwg==
X-Gm-Message-State: APjAAAU0lzTHkZYu+Q1RCcRYf0C2LYP2t6sIHJhSHLZop1s9vu4DBPTc
        ZuixPCH1Y1xvYEUK6z0fTA62KCJFYJk=
X-Google-Smtp-Source: APXvYqx/X+tRr1BLPXSiqduLUb4Ig945GZKaFlIATUn0+D6MBM+E/DtFRUiq+J1AeDrWpCzVoocRAQ==
X-Received: by 2002:a0d:e502:: with SMTP id o2mr138677ywe.33.1565954120523;
        Fri, 16 Aug 2019 04:15:20 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id r9sm1322587ywl.108.2019.08.16.04.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 04:15:20 -0700 (PDT)
Message-ID: <e392e00ed22ba37c37208988cf5a095150f6c45b.camel@redhat.com>
Subject: deprecating inline_data support for CephFS
From:   Jeff Layton <jlayton@redhat.com>
To:     ceph-users <ceph-users@ceph.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "dev@ceph.io" <dev@ceph.io>
Date:   Fri, 16 Aug 2019 07:15:18 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A couple of weeks ago, I sent a request to the mailing list asking
whether anyone was using the inline_data support in cephfs:

    https://docs.ceph.com/docs/mimic/cephfs/experimental-features/#inline-data

I got exactly zero responses, so I'm going to formally propose that we
move to start deprecating this feature for Octopus.

Why deprecate this feature?
===========================
While the userland clients have support for both reading and writing,
the kernel only has support for reading, and aggressively uninlines
everything as soon as it needs to do any writing. That uninlining has
some rather nasty potential race conditions too that could cause data
corruption.

We could work to fix this, and maybe add write support for the kernel,
but it adds a lot of complexity to the read and write codepaths in the
clients, which are already pretty complex. Given that there isn't a lot
of interest in this feature, I think we ought to just pull the plug on
it.

How should we do this?
======================
We should start by disabling this feature in master for Octopus. 

In particular, we should stop allowing users to call "fs set inline_data
true" on filesystems where it's disabled, and maybe throw a loud warning
about the feature being deprecated if the mds is started on a filesystem
that has it enabled.

We could also consider creating a utility to crawl an existing
filesystem and uninline anything there, if there was need for it.

Then, in a few release cycles, once we're past the point where someone
can upgrade directly from Nautilus (release Q or R?) we'd rip out
support for this feature entirely.

Thoughts, comments, questions welcome.
-- 
Jeff Layton <jlayton@redhat.com>

