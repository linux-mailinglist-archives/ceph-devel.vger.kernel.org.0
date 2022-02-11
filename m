Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1266C4B24B3
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Feb 2022 12:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349586AbiBKLq2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Feb 2022 06:46:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiBKLq1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Feb 2022 06:46:27 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4D9EAE
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 03:46:26 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f10so15958251lfu.8
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 03:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=McOiSDNoaeF50/hXDWelqddidRWV0jMwYc8ldu3TNkk=;
        b=RXWcdqDlHkbo8ZrQ/4/FRUQSWiETxIRhM/PfTwrxzTZhJghDT83Fp1w7Vj5XsmZbkp
         ftxPtWX6OyH9rv9S9RM2ZwE5DtsrI3qMMvr03AiZplZtRF9oS82mTMTQYfIGr7HqXhqz
         HymZZKhOKGeqoi0vJ61yO8GcRVtxUBQ+VglmWVo8R+6YCa4cty4DZXGJiNl2c9V2GkK1
         +P0zjglXDidc/WiNCbc+hVATzeG7np29AOoH5081X3LNORLrqX8nMIaSpIVrfgzWtLgK
         ENb+vhZjcPQ9t5tRJFMN78ixZ+Ekly2ABt0ibonhE2i0iieX0tA/SYCtynXZ4WpeV0Pq
         ZRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=McOiSDNoaeF50/hXDWelqddidRWV0jMwYc8ldu3TNkk=;
        b=2zUfeKFAnIcAmmETlktz99x0WUPiwchXTXIpCWy9IRs5n1IATB52BUeNpvCMhCmb+4
         4WZ5hw8ipI/ztx5zPxoy74KUUBY/siIp/e+D5HBXEQ04h1HBwLRa3ifBhiC5HReGY2xr
         cdlfAqq666elOStdGf53tNw3PdyETRTP2Qyv8aPOmFF9k7kJQzAU+9rgQ316KWspEs9S
         F+dDQluoP5OlXSwdJ5PhCnSC41H1VyqA6/L9VJk9yjtcdfmyyIEa0STPjn/QKBrG53zJ
         wyHvkF/hR0P6auuefAVKpxKSnksiw/rhsr6zNXFNmCtk/MtzHWE29rhlpdibgQ3W0YWp
         yh5g==
X-Gm-Message-State: AOAM532mdMzdwUYgUbvT/YojOBdmsLuEFRCtY7h8T16plGKD1Y3hEDkX
        GnspRJUZbQTpod04ouXumWPmdpazGcy/DuH5Bw==
X-Google-Smtp-Source: ABdhPJx73iVOBK2n6KXHvwEuWwvOn8JDig8v5HKFTT7NaRPmh/zA1XwS7w/4IzRxp0VzXPZqRe4//7PoLXWFEMwBi1g=
X-Received: by 2002:a05:6512:1083:: with SMTP id j3mr932357lfg.94.1644579985282;
 Fri, 11 Feb 2022 03:46:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:aa6:cd83:0:b0:19a:858a:7abd with HTTP; Fri, 11 Feb 2022
 03:46:24 -0800 (PST)
Reply-To: worldbankinternational002@aol.com
In-Reply-To: <CAApybxPgoBnENfVnG7xqC_HOpmcGFnW3H7kGb+1PDDyixiVTBA@mail.gmail.com>
References: <CAApybxMxFW1V5HGLfirSbwUxK4MqbRicMddiQOUkt+b3PUw5jg@mail.gmail.com>
 <CAApybxNQXd__tQk_LZUmkq6yJTKgZ-gTq-wrpJH+mXP+9kb3RA@mail.gmail.com> <CAApybxPgoBnENfVnG7xqC_HOpmcGFnW3H7kGb+1PDDyixiVTBA@mail.gmail.com>
From:   Ora bank <azukaike70@gmail.com>
Date:   Fri, 11 Feb 2022 11:46:24 +0000
Message-ID: <CAApybxO2a8UF8KHFxuamJ84gdZQGaKBVqPoxEFZZ9jt3MnQ55A@mail.gmail.com>
Subject: =?UTF-8?B?15zXoNem15cyMDIy?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

15TXkNedINen15nXkdec16og15DXqiDXlNee15vXqteRINei15wg15TXoNeZ16bXl9eV158g16nX
nNeaINep15nXk9eo15nXmiDXkNeV16rXmiDXk9eo15og15vXqteV15HXqiDXlNee15nXmdecINep
15zXmiA2LDUwMCQ/DQoxKSDXlNei15HXqNeUINee15HXoNenINec15HXoNenLg0KMikg157Xqdec
15XXlyDXm9eh16TXldee15gg15DXp9eh16TXqNehLg0K
