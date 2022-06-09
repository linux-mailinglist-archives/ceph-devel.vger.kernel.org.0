Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5187F54497E
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 12:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiFIKxK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 06:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiFIKxG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 06:53:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE01DA464;
        Thu,  9 Jun 2022 03:53:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6F57D21DB9;
        Thu,  9 Jun 2022 10:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654771983; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PpmQVxjR9EHUStcV+aF59APVHwIa7j+nyVOSQFjuOYk=;
        b=ifHgm9e2xYrEfBNtQ2MFninUZV4j4wYZtULaJkEfvDApf99uKg6N32eeHNlFfgt2xQKUVd
        T3pBAHgg94JhBN58N3kSaMoQQn7la/OJQqigidrgW/TdB1Tw95U0Le8kSq6PKqcWqH68C7
        WqzNMJEyxcfYIBmFoq9RUuAdqw6VzA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654771983;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PpmQVxjR9EHUStcV+aF59APVHwIa7j+nyVOSQFjuOYk=;
        b=x8VQrCKQNG0pNnPHeIOv1AyfbUjGDzm1H0RLgh2oUg8OkyB8sjMSmoZlk1W/u9oI/ANb16
        t3ADgAkZt1SjqcBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EA9E213456;
        Thu,  9 Jun 2022 10:53:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pbU5Ng7RoWK1EAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Jun 2022 10:53:02 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id e222422d;
        Thu, 9 Jun 2022 10:53:44 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2 0/2] Two xattrs-related fixes for ceph
Date:   Thu,  9 Jun 2022 11:53:41 +0100
Message-Id: <20220609105343.13591-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

A bug fix in ceph has made some changes in the way xattr limits are
enforced on the client side.  This requires some fixes on tests
generic/020 and generic/486.

* Changes since v1:

  - patch 0001:
    Set the max size for xattrs values to a 65000, so that it is close to
    the maximum, but still able to accommodate any pre-existing xattr

  - patch 0002:
    Same thing as patch 0001, but in a more precise way: actually take
    into account the exact sizes for name+value of a pre-existing xattr.

Luís Henriques (2):
  generic/020: adjust max_attrval_size for ceph
  generic/486: adjust the max xattr size

 src/attr_replace_test.c |  7 ++++++-
 tests/generic/020       | 10 +++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

