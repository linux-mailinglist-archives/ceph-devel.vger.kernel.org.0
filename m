Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879519B4CA
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2019 18:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405995AbfHWQpN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 23 Aug 2019 12:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387833AbfHWQpH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 23 Aug 2019 12:45:07 -0400
Subject: Re: [GIT PULL] Ceph fixes for 5.3-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566578706;
        bh=401L9q2plDtCB5nU2+0tkCczmKLSc0y/pUJJJtq7f2g=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Max1r8WF0jIUIgOCVzJPygSwsKi1zjMmDtSrk8Fytt5AhG0By6fDfivSiOx7wNmCt
         azjsPD8LYOIahrUcG0+a/xAMo/9nueWP+rAYb5nCu/JuUbImVMVkxY/ZUTLzEVR0wQ
         hd41WLhe6T4bXkE/bcKQd+DIA4ElZka3oF+tzy4I=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190823122726.15050-1-idryomov@gmail.com>
References: <20190823122726.15050-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190823122726.15050-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.3-rc6
X-PR-Tracked-Commit-Id: a561372405cf6bc6f14239b3a9e57bb39f2788b0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4e5639449069d12e95edc10b63acf170843e1706
Message-Id: <156657870685.6801.1793404829962707462.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Aug 2019 16:45:06 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 23 Aug 2019 14:27:26 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.3-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4e5639449069d12e95edc10b63acf170843e1706

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
