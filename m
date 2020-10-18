Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E93291700
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Oct 2020 12:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgJRKr6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 18 Oct 2020 06:47:58 -0400
Received: from out20-85.mail.aliyun.com ([115.124.20.85]:33891 "EHLO
        out20-85.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgJRKrt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 18 Oct 2020 06:47:49 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07504575|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0502353-0.00270697-0.947058;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Ikzw7qQ_1603018065;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Ikzw7qQ_1603018065)
          by smtp.aliyun-inc.com(10.147.42.16);
          Sun, 18 Oct 2020 18:47:45 +0800
Date:   Sun, 18 Oct 2020 18:47:40 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH 0/3] Initial CephFS tests (take 2)
Message-ID: <20201018104740.GZ3853@desktop>
References: <20201007175212.16218-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007175212.16218-1-lhenriques@suse.de>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 07, 2020 at 06:52:09PM +0100, Luis Henriques wrote:
> This is my second attempt to have an initial set of ceph-specific tests
> merged into fstests.  In this patchset I'm pushing a different set of
> tests, focusing on the copy_file_range testing, although I *do* plan to
> get back to the quota tests soon.

I have no knowledge about cephfs, I don't have a cephfs test env either,
so I can only comment from fstests' perspect of view. It'd be great if
other ceph folks could help review this patchset as well.

From fstests perspect of view, this patchset looks fine to me, just some
minor comments go to individual patch.

> 
> This syscall has a few peculiarities in ceph as it is able to use remote
> object copies without the need to download/upload data from the OSDs.
> However, in order to take advantage of this remote copy, the copy ranges
> and sizes need to include at least one object.  Thus, all the currently
> existing generic tests won't actually take advantage of this feature.
> 
> Let me know any comments/concerns about this patchset.  Also note that
> currently, in order to enable copy_file_range in cephfs, the additional
> 'copyfrom' mount parameter is required.  (Hopefully this additional param

I assume '_require_xfs_io_command "copy_range"' will _notrun the test if
there's no 'copyfrom' mount option provided, and test won't fail.

> may be dropped in the future.)
> 
> Luis Henriques (3):
>   ceph: add copy_file_range (remote copy operation) testing
>   ceph: test combination of copy_file_range with truncate
>   ceph: test copy_file_range with infile = outfile
> 
>  tests/ceph/001     | 233 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/ceph/001.out | 129 +++++++++++++++++++++++++
>  tests/ceph/002     |  74 ++++++++++++++
>  tests/ceph/002.out |   8 ++
>  tests/ceph/003     | 118 +++++++++++++++++++++++
>  tests/ceph/003.out |  11 +++
>  tests/ceph/group   |   3 +
>  7 files changed, 576 insertions(+)
>  create mode 100644 tests/ceph/001

New test should have file mode 755, i.e. with x bit set. The 'new'
script should have done this for you.

Thanks,
Eryu

>  create mode 100644 tests/ceph/001.out
>  create mode 100644 tests/ceph/002
>  create mode 100644 tests/ceph/002.out
>  create mode 100644 tests/ceph/003
>  create mode 100644 tests/ceph/003.out
>  create mode 100644 tests/ceph/group
