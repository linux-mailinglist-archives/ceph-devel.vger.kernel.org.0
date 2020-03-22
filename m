Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8813D18E75B
	for <lists+ceph-devel@lfdr.de>; Sun, 22 Mar 2020 08:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgCVHiZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 22 Mar 2020 03:38:25 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:46876 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgCVHiZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 22 Mar 2020 03:38:25 -0400
Received: by mail-oi1-f171.google.com with SMTP id q204so3600071oia.13
        for <ceph-devel@vger.kernel.org>; Sun, 22 Mar 2020 00:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=NiN3enolUaKKCB2CticcjdcE46gUpmkz9yyJQZCbSbs=;
        b=FNO0EY7TMBVkST5MHoU4tf9ZUI40zEncK4Wr6pVwbElrDalmktZuTWL3wKk3aQddKK
         BXG339gSLcQ6LwwoYKLzpkEM/teDhfpaI3+amh33PqYI+jn5ZshiQ2CTYj4fFbNI51Z4
         qWKx/qOCxkLPYAdbKXiqFz/qJTpiwfn75bdjgSHyL7egtgXhHzjVo/jKYgZT5ZAXt7sa
         lzuSW13f2kCFQZv5P5a4N61aY0KL952/70ioyOPVUAF7wBdYNAV+DreaGLi/HubFmmvn
         fcyF5C3xK39lGdsjMjl2XGoCAF7+UaMV+zlxwDq9P3Nm7f5mdZAu+BOQzj3ZQptt2E5f
         ygGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NiN3enolUaKKCB2CticcjdcE46gUpmkz9yyJQZCbSbs=;
        b=rl6DjxvGyXYFG6W/wS3Ew8DcExz09JirvgwsL9z/uRL3gMM5KvoMyRnFeqkYHA1Hn1
         oLcOmpyrznARz+MPKjP2LiJGzh4EdLB/mNQDSKD89kGdl0hV/dU35vkzJZmMq89Ve8hi
         +WCOHOGL3vi1YLMhw2xubs9JHEYXOv+HVmIXACV+pL63rXTP5wY5Kw3ns8qTcmBydizc
         A1pY7w6UKz+7lK4ylLdc0MBzSYd4B9nwmR/l3bFJPAQ01jxQkMQsPeqd34j88iNRNe6B
         Zuq0mxbU+2YAfBSWvt2ANNBWzxFpvmrLuyXbyMal8BvaHc85OsDn+z4rFnx2Mh5c/pQi
         48Rw==
X-Gm-Message-State: ANhLgQ3bujWpHHyoBfWuEyZb47ZLxq/VmFaQgTPyJCJE3DrI+pUhLOzN
        WeXaJy36VsFazWedst1SLpK36wIOp3UN69FJ0CCdH7Jx
X-Google-Smtp-Source: ADFU+vtx0QNxJs3ZJEE9ERfTKrvidpYg1fniiekar77VUTL0jQ+0tr3B8Xhz7Gqp8pfRBGzKGSJwMjjRuvHOwMbqwzo=
X-Received: by 2002:aca:af12:: with SMTP id y18mr12413516oie.78.1584862704361;
 Sun, 22 Mar 2020 00:38:24 -0700 (PDT)
MIME-Version: 1.0
From:   Xinying Song <songxinying.ftd@gmail.com>
Date:   Sun, 22 Mar 2020 15:38:13 +0800
Message-ID: <CAMWWNq-8H8JJsPdL1JC9pOKMQY9LawZDRxfKa7Ag8MWGJbBY5A@mail.gmail.com>
Subject: mds: where is mdr->slave_commit called?
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, everyone:
Could anybody give some tips about how `mdr->slave_commit` is called?

As for `link_remote()`, steps are as follows:
1. master mds sends OP_(UN)LINKPREP to salve mds.
2. slave mds replys OP_LINKPREPACK to master mds after its journal has
been flushed.
3. master mds continues to process the client request.

I only find out there is a chance in MDCache::request_finish() that
`mdr->slave_commit` will be called. However, after a successful
journal flush, slave mds only sends an ACK to master mds and bypasses
MDCache::request_finish().
So when or where is `mdr->slave_commit` called?

Thanks!
