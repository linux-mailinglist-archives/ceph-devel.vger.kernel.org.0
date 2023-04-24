Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2F26EC9D6
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Apr 2023 12:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjDXKKL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Apr 2023 06:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDXKKK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Apr 2023 06:10:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D0818B
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 03:10:09 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f27a9c7970so3843703f8f.2
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 03:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682331008; x=1684923008;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G7upYASidmeqEEydII3qqc7RD6bnaXjO6ELYE2uwAgE=;
        b=RuWTFBs7CUaAVC/IvDRy5zLz4TBQgP+4cdZk+bqBGI5ZKiLK+N7jYuAOV5Deeej1AR
         +qC2usE7kV+w5y/R1GJP9z5JdC8HR47iw0VgfIiV/8DcwwYuzsrRdlPZa5FRJYyTk5i2
         acFUfpQCEiK8VdLKM2JRvz1GmZbE1P9+qTQ2N1PlQNM+OyI2oM6ZSnN4Ihp9MoMcHuj3
         O20+yk+a+8yIeOAQn1WF7TSJu9AAv0BhTyV4Bk42g8yM5BzGE//9cffU0gMEY/q+zdZX
         6+k5awkgMudfZkTU+YjSvhatVpZlmZ00gjXZOHtdVqHh4xIbqR5+w9155vdgFKlsKJVM
         hKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682331008; x=1684923008;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G7upYASidmeqEEydII3qqc7RD6bnaXjO6ELYE2uwAgE=;
        b=U3AxcCfaY3ZyAfTQ0E6P9T55f3XkrkJy05X0GsXBD8Glx26HGV/3oSINlWwuhQ22cE
         b27yc0WCO8uJ97zrahvtiSIaJ2YNl1D+FbwQqeOoH14mSj6+4XduQ5IpHYhUJZF2cwDH
         gV9Qt/gDp0EIbgB0eCt8LUjsC9jNxYSXo0zGHfKaUm8WJSuxR8g2hd8D4GOEJud0aiTn
         XHh5ANASyAueuhtb9qVY/cF4vkyvFH9WU8nC4SsIp5iwjbGqFt+Edq1t+f3qDF4571bb
         ozuTIQwfldE5j098aJNUdnOs8Dlee5O/W1unq+StG4F6atmWGf5NP3DonhwOyTMo7kjh
         /CaQ==
X-Gm-Message-State: AAQBX9eMiVAH4bSYPhcJlEDa93Vk1wn1Mw9CU5PC9Nc/uunA/XTOCyG2
        xYcHh+ruHR+8t+vO2w7msowwp2SJW+ENCq8Zeyg=
X-Google-Smtp-Source: AKy350ZIkVshBHTAM5jl0bEFoZDDurVjsu+Z1xpp9ztYx7eXpKsTIIb+sKqS4jgqKq5RALcOu5QTXZyUuSwozEqtQaw=
X-Received: by 2002:adf:ea0c:0:b0:2f4:1953:37af with SMTP id
 q12-20020adfea0c000000b002f4195337afmr8881897wrm.16.1682331007823; Mon, 24
 Apr 2023 03:10:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:540f:0:b0:2bf:cbee:1860 with HTTP; Mon, 24 Apr 2023
 03:10:07 -0700 (PDT)
Reply-To: mariamkouame.info@myself.com
From:   Mariam Kouame <contact.mariamkouame4@gmail.com>
Date:   Mon, 24 Apr 2023 03:10:07 -0700
Message-ID: <CAHkNMZzDG3C5Unf2RKOjRHJyynWj6q=k3WJ4EJDmqecUGR7TZg@mail.gmail.com>
Subject: from mariam kouame
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you.I am looking forward to hearing from you at your earliest
convenience.

Mrs. Mariam Kouame
