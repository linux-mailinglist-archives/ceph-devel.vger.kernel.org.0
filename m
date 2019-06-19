Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2ED4BE89
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2019 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbfFSQpc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Jun 2019 12:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbfFSQpc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 12:45:32 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E99821537;
        Wed, 19 Jun 2019 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560962731;
        bh=kB3nUsz1fYNAiGj3UopgtiHKdqW2THI1cJKHLbgiGlM=;
        h=From:To:Cc:Subject:Date:From;
        b=Mmc/sVqNuRSnLHTiWp3VZctACHFcYtvcCuLLs4lHcT1O1/qRGA5QUClsLSP+309eV
         alR2SgfyP+IwKzf3jYyHL5vdnFVJim1k8k6E8ORqoA4O+GUA/QkqEIivZBodjKzEFd
         o4fTNxXbp+ZQIiXfN8SyfesoyamnAth7LRmeAsdA=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, sage@redhat.com,
        agruenba@redhat.com, joe@perches.com, pmladek@suse.com,
        rostedt@goodmis.org, geert+renesas@glider.be,
        andriy.shevchenko@linux.intel.com
Subject: [PATCH v2 0/3] ceph: don't NULL terminate virtual xattr values
Date:   Wed, 19 Jun 2019 12:45:25 -0400
Message-Id: <20190619164528.31958-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v2: drop bogus EXPORT_SYMBOL of static function

The only real difference between this set and the one I sent originally
is the removal of a spurious EXPORT_SYMBOL in the snprintf patch.

I'm mostly sending this with a wider cc list in an effort to get a
review from the maintainers of the printf code. Basically ceph needs a
snprintf variant that does not NULL terminate in order to handle its
virtual xattrs.

Joe Perches had expressed some concerns about stack usage in vsnprintf
with this, but I'm not sure I really understand the basis of that
concern. If it is problematic, then I could use suggestions as to how
best to fix that up.

----------------------------8<-----------------------------

kcephfs has several "virtual" xattrs that return strings that are
currently populated using snprintf(), which always NULL terminates the
string.

This leads to the string being truncated when we use a buffer length
acquired by calling getxattr with a 0 size first. The last character
of the string ends up being clobbered by the termination.

The convention with xattrs is to not store the termination with string
data, given that we have the length. This is how setfattr/getfattr
operate.

This patch makes ceph's virtual xattrs not include NULL termination
when formatting their values. In order to handle this, a new
snprintf_noterm function is added, and ceph is changed over to use
this to populate the xattr value buffer. Finally, we fix ceph to
return -ERANGE properly when the string didn't fit in the buffer.

Jeff Layton (3):
  lib/vsprintf: add snprintf_noterm
  ceph: don't NULL terminate virtual xattr strings
  ceph: return -ERANGE if virtual xattr value didn't fit in buffer

 fs/ceph/xattr.c        |  49 +++++++-------
 include/linux/kernel.h |   2 +
 lib/vsprintf.c         | 144 ++++++++++++++++++++++++++++-------------
 3 files changed, 129 insertions(+), 66 deletions(-)

-- 
2.21.0

