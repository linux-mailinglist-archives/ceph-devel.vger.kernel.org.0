Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AE41F206B
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Jun 2020 22:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgFHUFZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Jun 2020 16:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgFHUFY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 16:05:24 -0400
Subject: Re: [GIT PULL] Ceph updates for 5.8-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591646724;
        bh=jnK08mAfkMWGL456sL7IcuTGBY0+8FtULzjMebbboYQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=e9Mfu/Bj3SXPXezp7h5IUcZDwy6fB+tMh46zY0g9Pqj07qI/slefiXm6hfhdks1gT
         eKnz/fmkHsgANagf9ra93KAnW68YfP3jmBBC5Mwcse96DxMzobZA8Bg3c2lI2Zab1+
         YaVctQqB4l8KE1f4NhlMgFamiUBgPdBiUcixVdpo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200608163626.7339-1-idryomov@gmail.com>
References: <20200608163626.7339-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200608163626.7339-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.8-rc1
X-PR-Tracked-Commit-Id: dc1dad8e1a612650b1e786e992cb0c6e101e226a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 95288a9b3beee8dd69d73b7691e36f2f231b7903
Message-Id: <159164672399.26583.16571782263097298968.pr-tracker-bot@kernel.org>
Date:   Mon, 08 Jun 2020 20:05:23 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Mon,  8 Jun 2020 18:36:26 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.8-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/95288a9b3beee8dd69d73b7691e36f2f231b7903

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
