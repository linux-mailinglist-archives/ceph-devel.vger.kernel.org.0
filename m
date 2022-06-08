Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0AA54235C
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 08:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383695AbiFHCrW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 22:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385988AbiFHCiv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 22:38:51 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 650851666BF;
        Tue,  7 Jun 2022 17:16:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CAB6B5EC630;
        Wed,  8 Jun 2022 10:16:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nyjNK-003xZ3-R5; Wed, 08 Jun 2022 10:16:42 +1000
Date:   Wed, 8 Jun 2022 10:16:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/020: adjust max_attrval_size for ceph
Message-ID: <20220608001642.GS1098723@dread.disaster.area>
References: <20220607151513.26347-1-lhenriques@suse.de>
 <20220607151513.26347-2-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220607151513.26347-2-lhenriques@suse.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=629fea6d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=8nJEP1OIZ-IA:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=wmJgKgZtQlEYh2vbf0QA:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 07, 2022 at 04:15:12PM +0100, Luís Henriques wrote:
> CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
> size for the full set of an inode's xattrs names+values, which by default
> is 64K but it can be changed by a cluster admin.

So given the max attr name length is fixed by the kernel at 255
bytes (XATTR_NAME_MAX), that means the max value length is somewhere
around 65000 bytes, not 1024 bytes?

Really, we want to stress and exercise max supported sizes - if the
admin reduces the max size on their test filesystems, that's not
something we should be trying to work around in the test suite by
preventing the test code from ever exercising attr values > 1024
bytes.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
