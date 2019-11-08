Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9A9F5065
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Nov 2019 16:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfKHP6b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Nov 2019 10:58:31 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36661 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfKHP6b (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 Nov 2019 10:58:31 -0500
Received: by mail-wm1-f66.google.com with SMTP id c22so6751338wmd.1;
        Fri, 08 Nov 2019 07:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=54MaFm5VBMDV6T2K1upBSmgHCQwtV4l01lLVii97q6Y=;
        b=mv2joeqPloU9UDeNXUo3JCrcB64QG+nEy0VfqFs7HZa3wmRER8yz3CA478sLYVy+7s
         iCkS3TwmcKdRB5AcLPSS2c/dmJmUvwfwksrbiLVl8VAjQATB4dPXkoJS6OQr6bywAF5e
         c09BFDXGZp1G+/ITuGs45qE4SfdpslP5cpMOYJqmmC4D79j/h3nz0DEgVKlRYmxxNEXw
         GyA42I/WR4SO4gz9SmAX7i5I6feTckjsQ8mAhKhUG/UlBjA/Rq7Jk5D1bDBx9jhjRP7w
         UZPPkVBCrn8w9F70nUM2N3MBOWJIKHeqB0OwIBdXUWm3juL8krb54RjqYWaQXP/f4T+u
         iDmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=54MaFm5VBMDV6T2K1upBSmgHCQwtV4l01lLVii97q6Y=;
        b=ZK25eFOjCnXpQSxkpLSAIJcgxVJtNAWd1cTozNpTL9bbJFuKeKlwPjKJMrS9y8d0al
         R8OhTERgRVK/bBZsEB3w9wbW2Da9kz9t9p8LQck6S5GiSP6psjGwty8bihcwNi2XQSjN
         rTzKX+mL5SqxNoHuq0zpzpHvXMdJjOwU2C2twa8S9UzsZLUGjwKuNYirZY/aqTcIaHBi
         mBG5eIv8DPzsTgozIYXfqQwC+9r8E0FDDBH1bEckGb++BC0P3z8Ct+x3rg9fAnEKFTTM
         GRCbliMwzZ6ReqmsXQTZdBB36h5+8O/FrS/89bGd1ESv2QrkbTHkjnw/f7S2QqbYl/HV
         MpqQ==
X-Gm-Message-State: APjAAAXy7OVeE4NplNIU1yxHkN/rO8VbyI8xTnM2nwnoZ7Xn1+PlRKsN
        p4WeN4XQGKV96j44cUGQ3cTACBl+
X-Google-Smtp-Source: APXvYqxLU8zgDdkhQgCEpkb26FgMwUGhyh9oaKlyKHnXMeb1H0ep+XDOjg8W+GkhCGduqRGrz3jFtA==
X-Received: by 2002:a1c:1b0d:: with SMTP id b13mr8895424wmb.120.1573228707753;
        Fri, 08 Nov 2019 07:58:27 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h124sm7759434wmf.30.2019.11.08.07.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 07:58:26 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.4-rc7
Date:   Fri,  8 Nov 2019 16:58:53 +0100
Message-Id: <20191108155853.23314-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit d6d5df1db6e9d7f8f76d2911707f7d5877251b02:

  Linux 5.4-rc5 (2019-10-27 13:19:19 -0400)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.4-rc7

for you to fetch changes up to ff29fde84d1fc82f233c7da0daa3574a3942bec7:

  ceph: return -EINVAL if given fsc mount option on kernel w/o support (2019-11-07 18:03:23 +0100)

----------------------------------------------------------------
Some late-breaking dentry handling fixes from Al and Jeff, a patch to
further restrict copy_file_range() to avoid potential data corruption
from Luis and a fix for !CONFIG_CEPH_FSCACHE kernels.  Everything but
the fscache fix is marked for stable.

----------------------------------------------------------------
Al Viro (2):
      ceph: fix RCU case handling in ceph_d_revalidate()
      ceph: add missing check in d_revalidate snapdir handling

Jeff Layton (2):
      ceph: don't try to handle hashed dentries in non-O_CREAT atomic_open
      ceph: return -EINVAL if given fsc mount option on kernel w/o support

Luis Henriques (2):
      ceph: fix use-after-free in __ceph_remove_cap()
      ceph: don't allow copy_file_range when stripe_count != 1

 fs/ceph/caps.c  | 10 +++++-----
 fs/ceph/dir.c   | 15 ++++++++-------
 fs/ceph/file.c  | 15 +++++++++++++--
 fs/ceph/inode.c |  1 +
 fs/ceph/super.c | 11 ++++++++++-
 5 files changed, 37 insertions(+), 15 deletions(-)
