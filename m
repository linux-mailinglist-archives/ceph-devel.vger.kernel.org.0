Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C08214DDA0
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 16:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgA3PMS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 10:12:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:41466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgA3PMR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 10:12:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6CF3EB146;
        Thu, 30 Jan 2020 15:12:16 +0000 (UTC)
Date:   Thu, 30 Jan 2020 07:02:06 -0800
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH] rbd: optimize barrier usage for Rmw atomic bitops
Message-ID: <20200130150206.gdqn3bspghd2xtwz@linux-p48b>
References: <20200129181253.24999-1-dave@stgolabs.net>
 <CAOi1vP-75uoBBsnX262WoVL_jNreiSgnGmtytDKcsUE==ny2Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP-75uoBBsnX262WoVL_jNreiSgnGmtytDKcsUE==ny2Jw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 30 Jan 2020, Ilya Dryomov wrote:

>I don't think these barriers are needed at all.  I'll remove them.

Even better, thanks.
