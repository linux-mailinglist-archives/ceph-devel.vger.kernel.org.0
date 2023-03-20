Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CC06C14F3
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Mar 2023 15:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjCTOiS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Mar 2023 10:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjCTOiP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 20 Mar 2023 10:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D2E28219
        for <ceph-devel@vger.kernel.org>; Mon, 20 Mar 2023 07:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679323031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2SRGUfnMO8mvkZquFgCSC0Q62U00XVLCISUha9Gsgs=;
        b=aiF912UiQ7nQ/xtAFW3qj6woQlqg3nz1qo4QxgmRt2418ShQ/54phW8luUlCypH42WDihW
        EbiNMJupLheL0cwVkHZFR6uDqvg0htm8HNEmu6jFNC1524IDWczznFcVlE3o+5Oas7Ta1b
        LSApQbKmUKv3ZkaOodGMglHADbbMAl0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-xFJgGgQJMTqeG70zqXDqRw-1; Mon, 20 Mar 2023 10:37:10 -0400
X-MC-Unique: xFJgGgQJMTqeG70zqXDqRw-1
Received: by mail-pf1-f199.google.com with SMTP id l19-20020a056a0016d300b006257255adb4so6386394pfc.13
        for <ceph-devel@vger.kernel.org>; Mon, 20 Mar 2023 07:37:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679323029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2SRGUfnMO8mvkZquFgCSC0Q62U00XVLCISUha9Gsgs=;
        b=I4jTwQzimbrFGqpzXYib32hzPSbFXpVIwBJXyRZRBJRaR3OwrqoNhCmRsyO6rdUhQp
         P+9tFLDxbGtECqDZH9JCp5Ev5SLHmLhdmZ+SZsjGKZuGZGLDKfnV56VSXoU8ScL1gtK7
         IoprNbnYE4VwRfaDEBMOoinmfoLikm+Qb0rJIiNyZzGqQPpOxTrTXftIsIT70PqNEJST
         Gao2Ac8DniFyNlK8z+gt1ARC1rNdIY+S4lQNVmQGzGwAZzT72MWXyXs+WCE4cjj656D9
         9wC9sc5YFSQ8Su3EEOIUC45WR079oBFLdn+fIDnOUOXZpVoihiFmGwdsiKzKmyeX55D4
         SVAg==
X-Gm-Message-State: AO0yUKU8D40uIGWZfIzb9nZi9mSnT8KRXIlp/HL1L8bSNnYVKBZhJrJH
        JtTUcVDFF+Zug/tQb1JZzETMrWZ2dEevudKzPqGT0WimA88DHqd8/SF/9WA5o4wEk9Po8UkHCIa
        onAK5kQtl00BWEobzqVIfdUcE6g2PaU+6
X-Received: by 2002:a62:58c3:0:b0:627:ff1d:db6d with SMTP id m186-20020a6258c3000000b00627ff1ddb6dmr2158348pfb.21.1679323029240;
        Mon, 20 Mar 2023 07:37:09 -0700 (PDT)
X-Google-Smtp-Source: AK7set9MC3AehNPabTEgIcr03ArQquXmHUE8qgzqnu6YDS3r78eCJnkF54JWUwwwV5ZYtkm+x21FQw==
X-Received: by 2002:a62:58c3:0:b0:627:ff1d:db6d with SMTP id m186-20020a6258c3000000b00627ff1ddb6dmr2158326pfb.21.1679323028842;
        Mon, 20 Mar 2023 07:37:08 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z4-20020aa785c4000000b005810c4286d6sm6472979pfn.0.2023.03.20.07.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 07:37:08 -0700 (PDT)
Date:   Mon, 20 Mar 2023 22:37:03 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        ceph-devel@vger.kernel.org, vshankar@redhat.com
Subject: Re: [PATCH] generic/075: no need to move the .fsxlog to the same
 directory
Message-ID: <20230320143703.dv5ab4tnwrs5cnwl@zlang-mailbox>
References: <20230301020730.92354-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301020730.92354-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 01, 2023 at 10:07:30AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Actually it was trying to move the '075.$_n.fsxlog' from results
> directory to the same results directory.
> 
> Fixes: https://tracker.ceph.com/issues/58834
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  tests/generic/075 | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tests/generic/075 b/tests/generic/075
> index 9f24ad41..03a394a6 100755
> --- a/tests/generic/075
> +++ b/tests/generic/075
> @@ -57,7 +57,6 @@ _do_test()
>      then
>  	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
>  	mv $out/$seq.$_n $seqres.$_n.full
> -	mv "$RESULT_DIR"/$seq.$_n.fsxlog $seqres.$_n.fsxlog

Hmm... Thoese $seq, $seqnum, $seqres, $RESULT_DIR and $REPORT_DIR are mess for
me too :-D

From the logic of xfstests/check:

  if $OPTIONS_HAVE_SECTIONS; then
          export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;${RESULT_BASE}/$section;"`
          REPORT_DIR="$RESULT_BASE/$section"
  else
          export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;$RESULT_BASE;"`
          REPORT_DIR="$RESULT_BASE"
  fi
  seqres="$REPORT_DIR/$seqnum"


I think "$RESULT_DIR"/$seq equal to "$seqres", so this change makes sense to me.
(Not sure if there're some special situations which I don't know :)

The generic/075 is too old, lots of code in it can be removed or refactored, so
I think it's not worth changing it bit by bit, I can refactor it totally, or if
you'd like, you can do that.

Thanks,
Zorro

>  	od -xAx $seqres.$_n.full > $seqres.$_n.bad
>  	od -xAx "$RESULT_DIR"/$seq.$_n.fsxgood > $seqres.$_n.good
>  	rm -f "$RESULT_DIR"/$seq.$_n.fsxgood
> -- 
> 2.31.1
> 

