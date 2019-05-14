Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A0C1E5D0
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 01:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfENXvf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 May 2019 19:51:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:59904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726669AbfENXvf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 May 2019 19:51:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 43DF8AE3C;
        Tue, 14 May 2019 23:51:34 +0000 (UTC)
Date:   Wed, 15 May 2019 01:51:32 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Jeremy Allison <jra@samba.org>
Cc:     Jeremy Allison via samba-technical 
        <samba-technical@lists.samba.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH] Samba: CephFS Snapshots VFS module
Message-ID: <20190515015132.71466b98@suse.de>
In-Reply-To: <20190514210030.GE210466@jra4>
References: <20190329184531.0c78e06b@echidna.suse.de>
        <20190508224740.GA21367@jra4>
        <20190510151601.798bee61@suse.de>
        <20190510185841.GA54524@jra4>
        <20190513122738.78b2b566@suse.de>
        <20190514210030.GE210466@jra4>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 14 May 2019 14:00:30 -0700, Jeremy Allison wrote:

> If you're happy, please push ! Thanks for your patience
> with the review, sorry it's been a bit of a struggle (but
> as I said I *really* want this change :-).

Pushed - thanks a lot for your thorough review Jeremy!

Cheers, David
