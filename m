Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A20A7BF2FA
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Oct 2023 08:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442249AbjJJG1U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Oct 2023 02:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442248AbjJJG1T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Oct 2023 02:27:19 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57EEBA
        for <ceph-devel@vger.kernel.org>; Mon,  9 Oct 2023 23:27:17 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-32c9f2ce71aso349360f8f.1
        for <ceph-devel@vger.kernel.org>; Mon, 09 Oct 2023 23:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696919236; x=1697524036; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ri9EKRL9KIpCxIS9ro/yli5p5EOl1LURZZBjNQ94PTo=;
        b=QaHAFPTMAW9ioYk8qe9OvRtMW/51GTAmpSKFagyqLKEmEPGKTvm7Vr67/AL5Wsjt9M
         WonUJbQwNcSstIjPXba7ah8EEBfvNQgoM3YFCx4OTPPs1CY+bBIZonjx/lS5Pfn+K9iV
         ZALbwQvXGdZC/J7q/M2J2Ltr1vQlUjtf0o/c0dA/NcZUbUATX0lzDTpDlO05YUZolLn7
         iLb+qCsv3iMp6x9Y8+DjhVNjcLqh1HEw8Gm3Mhg/X5hXHdxXJzg7Jeaiv7hmfGnhSSkG
         //qNkinpXikJvMeh4rIObSWJqwTVt6UYngezCSpJqRAP4+y8dpxuMbNn0Rw4UJd1uMF3
         UD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696919236; x=1697524036;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ri9EKRL9KIpCxIS9ro/yli5p5EOl1LURZZBjNQ94PTo=;
        b=w16mIhGcF1vJH4u+W10ucPmaefPgI0zBxQX9/UipGVBBg0XeXP3lJJsgU2Le026aqr
         623EiAwcB3PbKX7nAbAZDYQdVNY2R+35yjdqv7GqKgCuxXm85drkzpbPOLuzQ5obkMnz
         cqCGR5V68DBcMJ7lAWnaoRaiiQ3ofLlNRzbkCE/XZor5UeLxpM4NKG5JkrI6H+KY23FJ
         3jR88virnVqK+Wsq8ftA5G8dP5S1MDOuH1KW5AiKVDPp/ss2D1Lvkf4EmVnEU/0dpWdq
         pAhiP1CIbqKloqZm2hvjqSZ1cAod9CZc/azZPjLpZTEeBH/fripRCXPIGJXI9i428vzt
         ES6A==
X-Gm-Message-State: AOJu0YwHvxC5RO45rbGvtz5/8aETGh2oLZjQWeje/VkTRY0/ULQ5U97s
        wBuGZtOAXGYRSaEYgiIQXNvRSQ==
X-Google-Smtp-Source: AGHT+IE+N98c4s/xb+S/dtBcmAo4nHFFZliG6hDnBwvWeNQTOEdiAzf+3Co5YyLLg9hsrpVEFkyb3g==
X-Received: by 2002:adf:eac3:0:b0:322:dbc6:8cf7 with SMTP id o3-20020adfeac3000000b00322dbc68cf7mr14766445wrn.16.1696919236163;
        Mon, 09 Oct 2023 23:27:16 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v15-20020a5d4b0f000000b00325aca09ad1sm11681034wrq.24.2023.10.09.23.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 23:27:15 -0700 (PDT)
Date:   Tue, 10 Oct 2023 09:27:12 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ceph: fix type promotion bug on 32bit systems
Message-ID: <987bade1-8753-437b-a5c0-f593a2629caf@kadam.mountain>
References: <5e0418d3-a31b-4231-80bf-99adca6bcbe5@moroto.mountain>
 <87sf6jrk2t.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sf6jrk2t.fsf@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 09, 2023 at 02:39:38PM +0100, Luis Henriques wrote:
> Dan Carpenter <dan.carpenter@linaro.org> writes:
> 
> > In this code "ret" is type long and "src_objlen" is unsigned int.  The
> > problem is that on 32bit systems, when we do the comparison signed longs
> > are type promoted to unsigned int.  So negative error codes from
> > do_splice_direct() are treated as success instead of failure.
> >
> > Fixes: 1b0c3b9f91f0 ("ceph: re-org copy_file_range and fix some error paths")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> > 32bit is so weird and ancient.  It's strange to think that unsigned int
> > has more positive bits than signed long.
> 
> Yikes! Thanks for catching this, Dan.  Really tricky.  I guess you used
> some static analysis tool (smatch?) to highlight this issue for you,
> right?

Yes.  I've pushed this check but you need the cross function DB to know
which functions return error codes so most people won't see the warning.

regards,
dan carpenter

