Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4DE17A05
	for <lists+ceph-devel@lfdr.de>; Wed,  8 May 2019 15:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbfEHNLn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 May 2019 09:11:43 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:35091 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbfEHNLm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 May 2019 09:11:42 -0400
Received: by mail-wm1-f46.google.com with SMTP id y197so3211875wmd.0
        for <ceph-devel@vger.kernel.org>; Wed, 08 May 2019 06:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=nwKiifr2CmcCo7jObhcy1u6icvCNo1xuhOaN88dd2vY=;
        b=S+Nlxr9zGqQebOMv0nPf/OvBMuNWJkGckP8Vf8Au8a4qgz4AzaCzWNhOfjT0s95YDP
         ttYubgf7UPQQ/OY2bDUBe96Rw5BPbYwIY1ms0FlBvy7BzqRWqoLSIrn1rDizGZBM661b
         EaujaxI7+gf0yMYdeUw9LgDbWGolcbzYicBkc59/oTinRCu1sGAws/MPdHiu2182RpN4
         1OlRCzKbufIPpsps6kJMnIn9kgl0q7OqKeN/1UIGPOouXE87Xcnmpl11BoYbfdpLTMB5
         F0rSk6hNK51u/7aFVJQ8WjJwecT3WSTuf+2HXpAfYTD7O/De02ObMPAYmk1SfX53OIDM
         /+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nwKiifr2CmcCo7jObhcy1u6icvCNo1xuhOaN88dd2vY=;
        b=VYxIrJ5K82OoDdSTqzbScNXv4FxWFgPxuK9hb1mB7GBtZILjCEpC9rpqKfUpU3lA/w
         X42bWis4Xqw5Abh2ljD0BKVhiNFEctWsWZQB1HU3X826sCWpnKEZu9Xau+Cv9nk1XXyh
         54u9y26rGj+jqrPJJGQzNDL/McngTTOCi1uWMGlB1uhmkYRyhgezqgQrIUTVSy0Q5nJb
         Ht+KHE47HaoMAztd5Xb8eKo67eE/anbtjn+VW0vo628wheOEeLabtcrQcBPEshwngv1n
         VCpnD/8iU5yNqFi6PlBJnp54R5RgYDNK590su/vOwyNp/Jdq1C0zpGGIgHtJC7FOuv2B
         9maw==
X-Gm-Message-State: APjAAAUQyIknBM5kI/MxEZXCHF5e95QW9UHTVbeHePdwKFedywXYx3yV
        F12Lc6FdGVoxb7WBOJwT4n4j+qsGsRtdB1Hfy3lGcdmi
X-Google-Smtp-Source: APXvYqxF+nkaNBcQPem0mr1MKC3CU1kUPbQU7mOa1Hrqf0GwiXqM1r4Qt2GGeUdZFwqKEPFmNGKu3xHJi+z/bsGY9aQ=
X-Received: by 2002:a1c:304:: with SMTP id 4mr3054142wmd.39.1557321100015;
 Wed, 08 May 2019 06:11:40 -0700 (PDT)
MIME-Version: 1.0
From:   zengran zhang <z13121369189@gmail.com>
Date:   Thu, 9 May 2019 05:11:03 +0800
Message-ID: <CALi+v1_fTKgpKtMTBDw3ioy4SqtsvP3xkjXLyLX5Gb=_7yoaNg@mail.gmail.com>
Subject: some questions about fast dispatch peering events
To:     Sage Weil <sweil@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Sage:

  I see there are two difference between luminous and upstream after
the patch of *fast dispatch peering events*

1. When handle pg query w/o pg, luminous will preject history since
the epoch_send in query and create pg if within the same interval.
    but upstream now will reply empty info or log directly w/o create the pg.
    My question is : can we do this on luminous?

2. When handle pg notify w/o pg, luminous will preject history since
the epoch_send of notify and give up next creating if not within the
same interval.
    but upstream now will create the pg unconditionally, If it was
stray, auth primary will purge it later.
    Here my question is: is the behavior of upstream a specially
designed improvement?

I would appreciate it if you could give some explication, thanks!
