Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF525A9D9
	for <lists+ceph-devel@lfdr.de>; Sat, 29 Jun 2019 11:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfF2JaH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 29 Jun 2019 05:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbfF2JaG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 29 Jun 2019 05:30:06 -0400
Subject: Re: [GIT PULL] Ceph fix for 5.2-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561800604;
        bh=gcn45gUL5QFiNKW/pb6fBQfCLhvsHm7eOBySFmuvjhw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=2Hex3atGJowbepA1xjjskGySeC9onA9fKUP+oClCpED0SVr6FkYGr50fMuy3nw6vy
         ILM+lSSCvNEE8UWuXwRzSBsgtRH9BwsdqFUhuu06kw/CTu/j+68ywp7+p96s5cs78C
         E07CBF1Bq5jenWm+iqBRO0hN58HgROm1TYOTs1Mw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190628151724.5642-1-idryomov@gmail.com>
References: <20190628151724.5642-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190628151724.5642-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.2-rc7
X-PR-Tracked-Commit-Id: d6b8bd679c9c8856fa04b80490765c43a4cb613b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 43251dbd6ac278a8bdaaee43ec5e299c1a5dafdd
Message-Id: <156180060420.8003.14726926142083769663.pr-tracker-bot@kernel.org>
Date:   Sat, 29 Jun 2019 09:30:04 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 28 Jun 2019 17:17:24 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.2-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/43251dbd6ac278a8bdaaee43ec5e299c1a5dafdd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
