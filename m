Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFB2518A8
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732097AbfFXQ13 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jun 2019 12:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfFXQ13 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 12:27:29 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD37820657;
        Mon, 24 Jun 2019 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561393648;
        bh=NGCvQfasyw2Dvd+0f5kMeX1GDlGQsRX0xZnViuUsN6U=;
        h=From:To:Cc:Subject:Date:From;
        b=uw9ookjg3azfCRvSEDTpj9uKwHEplhQMWpbdn/F08DMG753KLBEunNP20XNOudvTd
         KiGVq2ma/ffje1wpZIY21Pr+9XxZ2wKnsDJSNrem4JFUUW+hSh8zCNBnnA7gb2Ka7q
         34NOGjLeUhL+4M/YtT4ZAMRRVDDm2435CcMqvg70=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, sage@redhat.com,
        agruenba@redhat.com
Subject: [PATCH v4 0/3] ceph: don't NULL terminate virtual xattrs
Date:   Mon, 24 Jun 2019 12:27:23 -0400
Message-Id: <20190624162726.17413-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v4: resurrect snprintf_noterm as static function that uses a
    fixed-size intermediate buffer.
    Return -E2BIG and WARN if the formatted string exceeds temp buffer.
    make getxattr_cb callbacks return ssize_t.
v3: switch to using an intermediate buffer for snprintf destination
    add patch to fix ceph_vxattrcb_layout return value
v2: drop bogus EXPORT_SYMBOL of static function

This is the 4th posting of this patchset. In this variant, we add a new
variatic static function that uses an internal buffer and calls
vsnprintf to do the formatting, and then memcpys the result into the
buffer. This also adds a bit of type-sanity cleanup of the vxattr
handling in general.

Most of the rationale for this set is in the description of the last
patch of the series.

Jeff Layton (3):
  ceph: make getxattr_cb return ssize_t
  ceph: return -ERANGE if virtual xattr value didn't fit in buffer
  ceph: don't NULL terminate virtual xattrs

 fs/ceph/xattr.c | 182 ++++++++++++++++++++++++++++--------------------
 1 file changed, 108 insertions(+), 74 deletions(-)

-- 
2.21.0

