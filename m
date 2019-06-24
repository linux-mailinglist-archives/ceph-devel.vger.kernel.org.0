Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4500D4FF05
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 04:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfFXCFK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Jun 2019 22:05:10 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:39063 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfFXCFJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 23 Jun 2019 22:05:09 -0400
Received: by mail-lj1-f174.google.com with SMTP id v18so10926273ljh.6
        for <ceph-devel@vger.kernel.org>; Sun, 23 Jun 2019 19:05:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2csDHUwsfZ9vKiM6L0X2VwRtlMfkReR7eWIJEs97n9I=;
        b=AxnmY62N/xc5mf86chf+4x/ysAwZ2iKlvdhH0XANeWVxSCkwBQFPh7nKlrKcBrjFnl
         CgG3XgDNY6Zir0ybkTw7yUnhnAoSWFaZM9EGD4rMQUUOMzjNOnGWTCoPWiiZPOnz8p0t
         L72Vhz2qW60ACxCCllA9k+mpgxXKz66kOPFTBkEZnUW7brtvclva3UmmEhMrvbUZE30l
         h7d9x4zv7YxfrQ94Rd3RCN6d+T0DREsAb9lCosypn/Nq/QRw5yfzhMZb4u56j2PHmlxl
         ltZhctYaJidHWm2lnKRaEhoqM+UGAcO2clQ4PyYOTwXLLIZ6qT969U/0TLJUt3Ya8R+O
         oHzw==
X-Gm-Message-State: APjAAAXaKh2XF/XPAQzUWCFJ8HWfAIHxiaKoF1e8cjNH15UJHKAiksE8
        TXe0qlyhakfJ00QWCFqhtpJOlTRR1q7JwfGK9X2NbB6lUcQ=
X-Google-Smtp-Source: APXvYqyFFa94zdzVlIUdrabK3DjRXVKbih0Jw0P/AyP18VGEctB3LSXrDL9x/xmbcJAn06b4km1fNWU4ZDepLWMgDao=
X-Received: by 2002:a2e:25a:: with SMTP id 87mr61053114ljc.183.1561341908007;
 Sun, 23 Jun 2019 19:05:08 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Mon, 24 Jun 2019 12:04:56 +1000
Message-ID: <CAF-wwdHpZ67i72Ude0U=NTQ02rauvKv0Ue_-Lh4PURq4u-tTSA@mail.gmail.com>
Subject: Static Analysis
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest static analyser results are up on  http://people.redhat.com/bhubbard/

Weekly Fedora Copr builds are at
https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/

-- 
Cheers,
Brad
