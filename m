Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46405384AD
	for <lists+ceph-devel@lfdr.de>; Mon, 30 May 2022 17:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241239AbiE3PWD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 May 2022 11:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243003AbiE3PU4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 May 2022 11:20:56 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549F31790B6
        for <ceph-devel@vger.kernel.org>; Mon, 30 May 2022 07:22:59 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z20so11487967iof.1
        for <ceph-devel@vger.kernel.org>; Mon, 30 May 2022 07:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=XJqXgw0Qi4Ge6Q57wB4GlvotoYnhUuSq68y9152a6AE=;
        b=Uon8wdSqHAkD3+idsDwqsw5/RYE9GUuamAt3cXARqV3NAeDaGTFSLoXs/G0hoAHt+5
         codSJJxeeG8vzFjwPvQIVi8pQwh8BHkUEnJ12EbeOHHixGjwXNoKXbv093UEgoEUQfeX
         Wod0GKDhAdiR/Ye/ytirv8v0lLWuUvpQJix1wPyUwccxWGh+xUage9MXo7G5h4Fk521r
         DI2oe8/v8oseOn3Ob0K+CIOBqiMgej7MNHpUOxL774B1gIBhklt7oanUcWy5rMkcHIBO
         DPJxFGRqOeAdN5gDE89YSbgO4qUovR5BE7nFCFMjyJGWrnHFIj5hKg5UUE4gd+cXFCdp
         hO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=XJqXgw0Qi4Ge6Q57wB4GlvotoYnhUuSq68y9152a6AE=;
        b=u3IJybnJRfCBg4pF72ColweAWpZq24UGZm+vE6uAf4XEWMjgHrXlCI1nCM3OrQ7hZE
         Zmg9HMpxuUuVN8QhvNOiKRDr8KBd4BA7kNkOOAVVGM/0ZF+LvANxNJxu28NiF/SgaatJ
         wTowuReOS1FXNUI4fnafUyQrAMLduOglZDu5HMp4wBhjAKeaN82q2Bhew8eKCKR1vwWZ
         83Vny2RB3frxtzhfi6RjcWRZHN4Jooy2kVGxZWgX2yf27lvBCpFZRDIpzr/jYV8K6201
         wX+JZJri1792QSlFgh/u1rIHpmtgQOoJE/xxS241diOje0YLm96mUueDsE7wUVbaBdnH
         Gu3Q==
X-Gm-Message-State: AOAM532lso6nytbo2X9o1Bdkf4HrnN0I6i0a1aBaYTYSf7OR68IMjNSj
        bAEooLAI0RwfRjyJWLI6gAxEn3q59faixJaLk9o=
X-Google-Smtp-Source: ABdhPJwtvJ+07dKTyr7TpOGjLPDpnwsexIyHiV/hfgzfTPNlT+ipRRN6pgsw9s1i3X6T+BTCXU16HSeeuxtReVm1TBY=
X-Received: by 2002:a05:6638:498e:b0:32e:be76:f908 with SMTP id
 cv14-20020a056638498e00b0032ebe76f908mr20858880jab.66.1653920570933; Mon, 30
 May 2022 07:22:50 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6622:f06:0:0:0:0 with HTTP; Mon, 30 May 2022 07:22:50
 -0700 (PDT)
Reply-To: barristerbenjamin221@gmail.com
From:   Attorney Amadou <koadaidrissa1@gmail.com>
Date:   Mon, 30 May 2022 07:22:50 -0700
Message-ID: <CAOh7+P_+cJJknP6BJXj8NWX7nn8nkbA=aoSG2t49pestA9PG0g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d43 listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [koadaidrissa1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [barristerbenjamin221[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [koadaidrissa1[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

SGVsbG8gZGVhciBmcmllbmQuDQoNClBsZWFzZSBJIHdpbGwgbG92ZSB0byBkaXNjdXNzIHNvbWV0
aGluZyB2ZXJ5IGltcG9ydGFudCB3aXRoIHlvdSwgSQ0Kd2lsbCBhcHByZWNpYXRlIGl0IGlmIHlv
dSBncmFudCBtZSBhdWRpZW5jZS4NCg0KU2luY2VyZWx5Lg0KQmFycmlzdGVyIEFtYWRvdSBCZW5q
YW1pbiBFc3EuDQouLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4NCuimquaEm+OB
quOCi+WPi+S6uuOAgeOBk+OCk+OBq+OBoeOBr+OAgg0KDQrnp4Hjga/jgYLjgarjgZ/jgajpnZ7l
uLjjgavph43opoHjgarjgZPjgajjgavjgaTjgYTjgaboqbHjgZflkIjjgYbjga7jgYzlpKflpb3j
gY3jgafjgZnjgIHjgYLjgarjgZ/jgYznp4HjgavogbTooYbjgpLkuI7jgYjjgabjgY/jgozjgozj
gbDnp4Hjga/jgZ3jgozjgpLmhJ/orJ3jgZfjgb7jgZnjgIINCg0K5b+D44GL44KJ44CCDQrjg5Dj
g6rjgrnjgr/jg7zjgqLjg57jg4njgqXjg5njg7Pjgrjjg6Pjg5/jg7NFc3HjgIINCg==
