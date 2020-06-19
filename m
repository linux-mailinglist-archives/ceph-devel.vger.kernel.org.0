Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45B8201B43
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jun 2020 21:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388669AbgFSTa0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jun 2020 15:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388587AbgFSTaX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 19 Jun 2020 15:30:23 -0400
Subject: Re: [GIT PULL] Ceph fixes for 5.8-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592595023;
        bh=4CyzdlmLdjpkF3YA5KXNHCXDN/3S7EZxaRbD8U7Ho/U=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=nSc60p4LAeEwEeUjmHsY2V9o4Fnj7Zog0uqUIPvVGWz6wntZgDr4ZjGB19/st/pA9
         ozLe2wHvEEnJrC9EIPUIaWuYrRjAV53+0oouZDTniPIgEjvclJ5M0NI7jnJEPKreqj
         FURZZlHy8ccBXybP4HFepxWqXBNI0HxulGj57gK0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200619123547.14353-1-idryomov@gmail.com>
References: <20200619123547.14353-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200619123547.14353-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.8-rc2
X-PR-Tracked-Commit-Id: 7ed286f3e061ee394782bd9fb4ed96bff0b5a021
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 672f9255a727d04c98b05ba7af625ab7032c8028
Message-Id: <159259502339.2705.15825277458052180337.pr-tracker-bot@kernel.org>
Date:   Fri, 19 Jun 2020 19:30:23 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 19 Jun 2020 14:35:47 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.8-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/672f9255a727d04c98b05ba7af625ab7032c8028

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
